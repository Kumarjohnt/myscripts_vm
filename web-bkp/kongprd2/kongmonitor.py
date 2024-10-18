"""
Kongmonitorscript
Script Maker    : Vaddi Srinivas(srinivasv@vmware.com)
Date            : Sept 25th 2019
"""

#!/usr/bin/python
# -*- coding: utf-8 -*-
try:
    from datetime import datetime
    import subprocess
    import traceback
    import json
    import time
    from time import sleep
    import logging
    from logging import debug, error, info, warning
except Exception as GENERIC_EXCEPTION:
    print('Import failure ' + GENERIC_EXCEPTION)

# used to look at 'Time Taken in Response from curl -v'
DELAYED_RESPONSE = '5'

#this is 'vip'-timeout
CONNECT_TIMEOUT = '5'

PING_SUCCESS_CODE = 0
PING_TIMEOUT_CODE = 124

#used in 'kongcommand'
CURL_COMMAND_TIMEOUT = '5'


#used in 'kongcommand'
TOKEN_TOTAL_TIME = '5'

# ping timeout
PING_TIMEOUT = '1'

# in integer as  sleep accepts in integer
SLEEP_TIME = 15.0
TOTAL_TIME = 0.0

# keys
KEYS_IN_RESPONSE = ['access_token', 'token_type', 'expires_in']

# count of failures, when more than tolerant count
COUNT_OF_FAILURES = 0
TOLERANT_COUNT = 3

# files involved
FILE_TO_MODIFY = \
    '/etc/nginx/load-balancer-monitor/load-balancer-monitor/success.html'
ERROR_FILE = '/home/kongadmin/script.log'
TMP_FILE = '/home/kongadmin/tmp_file'
DUMP_FILE = '/home/kongadmin/dump.log'

# kong strings
KONG_COMMAND = 'timeout ' + CURL_COMMAND_TIMEOUT \
    + """ curl -w "
Output:
 HTTP Status: %{http_code}
 Time taken for DNS lookup: %{time_namelookup}
 Connect time to VIP: %{time_connect}
 Time to receive first byte from backend: %{time_starttransfer}
 Total Time for Response : %{time_total}
" -v -s --connect-timeout """ + CONNECT_TIMEOUT + " -X POST "

START_IN_VERBAL = '"access_token"'
END_IN_VERBAL = 'Output:'
KONG_HOSTS = [
    'apikong-prd2.tkg.vmware.com']
KONG_VIP = 'apikong-prd2.tkg.vmware.com'
KONG_URL = 'https://apikong-prd2.tkg.vmware.com/monitoring?id='
CONNECTED_TO_STRING = ' Connected to ' + KONG_VIP


logging.addLevelName(logging.ERROR, 'Error')
logging.addLevelName(logging.CRITICAL, 'Critical')
logging.addLevelName(logging.WARNING, 'Warning')
logging.basicConfig(filename=ERROR_FILE, filemode='a',
                    format='%(asctime)s,%(msecs)d  %(levelname)s> %(message)s',
                    datefmt='%d/%m/%Y %Z %H:%M:%S',
                    level=logging.DEBUG)


def run_on_shell(PARAM, SHELL_STATUS=True):
    """
        This method just takes the shell commands to be executed and returns
        what this command outputs in shell
        :param param: command (example "ls")
        :return: output on shell
        """
    try:
        SHELL_OUTPUT = subprocess.Popen(
            [str(PARAM)],
            shell=SHELL_STATUS,
            bufsize=0,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=False,
        ).communicate()[0].decode('utf-8').strip()
        return SHELL_OUTPUT
    except Exception as GEN_ERROR:
        error('Error with execution in get_str ' + str(GEN_ERROR))
        return GEN_ERROR


def curl_v_parser(param):
    """
    this takes the kong command and returns bool
    :param param:
    :return:
    """
    LINE_CONN = 0
    INDEX_STARTS_AT = 0
    STATUS = False
    JSON_FLAG = False
    VIP_FLAG = False
    CURL_RESP = str(param).splitlines()

    # for loop breaks when it hits start_in_v

    for (COUNT, LINE) in enumerate(CURL_RESP):
        # debug(line.strip())
        if CONNECTED_TO_STRING in LINE.strip():
            info(LINE)
            VIP_FLAG = True
        if START_IN_VERBAL in LINE.strip():
            JSON_FLAG = True
            debug('Found json! start_in_v')
            INDEX_STARTS_AT = COUNT
            break
    if not VIP_FLAG:
        error('Connection with VIP FAILED')
        return False
    if not JSON_FLAG:
        debug('Index of start of json : %d' % INDEX_STARTS_AT)
        error('Did not find the token, moving into panic mode')
        return False

    debug('Index of start of json : %d' % (INDEX_STARTS_AT - 1))
    SHELL_OP_CURL = ''.join(CURL_RESP[INDEX_STARTS_AT
                                      - 1:]).split('Output:')

    # debug(shell_output)
    TOTAL_TIME_TAKEN = float(SHELL_OP_CURL[1].encode('utf-8').strip().splitlines()[-1]
                             .split(':')[-1].strip())
    RESP_JSON = json.loads(SHELL_OP_CURL[0])

    [debug(ITER + ';') for ITER in SHELL_OP_CURL[1].strip().splitlines()]
    VERBOSE_STATUS = (False if TOTAL_TIME_TAKEN >
                      float(TOKEN_TOTAL_TIME) else True)
    TOKEN_STATUS = (True if RESP_JSON.keys() == KEYS_IN_RESPONSE
                    and str(RESP_JSON['access_token']).strip() != ''
                    else False)
    debug('Verbose status : %r , Token status : %r' % (VERBOSE_STATUS,
                                                       TOKEN_STATUS))
    if VERBOSE_STATUS and TOKEN_STATUS:
        info('Transaction successful')
        return True
    elif not TOKEN_STATUS:
        error('Invalid Token')
    elif not VERBOSE_STATUS:
        error('Delayed Response')
    elif not VERBOSE_STATUS and not TOKEN_STATUS:
        error('Error with Token generation, invoking to panic_mode')
    return STATUS


def file_modify(FILE_TO_READ, FROM_STRING, TO_STRING):
    """
    This function takes a file, and modifies FROM_STRING to TO_STRING from the  File,
     provided, FROM_STRING doesnt exist
    :param FILE_TO_READ: Filename
    :param FROM_STRING: "changeit"
    :param TO_STRING: "tothis"
    :return:
    """
    try:
        #debug("Modifying file")
        #debug(" From : %s ; To : %s"%(from_,to_))
        STRINGIFY_FILE = open(FILE_TO_READ).read()
        if FROM_STRING not in STRINGIFY_FILE:
            debug(FROM_STRING + " not in file, exiting")
            return "No such string"
        else:
            debug(FROM_STRING + " in file, modifying")
            CHANGED_STR = STRINGIFY_FILE.replace(FROM_STRING, TO_STRING)
            FILE_TO_CHANGE = open(FILE_TO_MODIFY, 'w')
            FILE_TO_CHANGE.write(CHANGED_STR)
            FILE_TO_CHANGE.close()
            return "File Modified to " + TO_STRING
    except Exception as GEN_ERROR:
        error("Error  in modifying file " + str(GEN_ERROR))
        return "Error"


def ping_maker(HOST_TO_PING):
    """
    This takes a host to ping and pings via shell,
    :param HOST_TO_PING:
    :return:
    """
    COUNTER_PING = 0
    PING_FLAG=True
    global SLEEP_TIME
    START_PINGTIME = time.time()
    debug("Initiating Ping to "+HOST_TO_PING)
    while COUNTER_PING < 3:
        CYCLE_PING_TIME = time.time()
        try:
            # , SHELL_STATUS=False)
            response = run_on_shell(
                'timeout ' +
                PING_TIMEOUT +
                ' ping -c 1 ' +
                HOST_TO_PING +
                ";echo $?")
            debug("PING output is " + str(str(response).splitlines()))
            debug("PING RESPONSE IS : " + str(response).splitlines()[-1])
            response = str(response).splitlines()[-1]
            if int(response) == PING_SUCCESS_CODE:
                debug("Ping Successful")
                debug("Ping count : " + str(COUNTER_PING + 1) +
                      " Response : " + str(response))
                PING_FLAG=True
            elif int(response) == PING_TIMEOUT_CODE:
                debug("PING TIMEDOUT " + response)
            else:
                debug("Ping Failed")
                debug("Ping count : " + str(COUNTER_PING + 1) +
                      " Response : " + str(response))
            if PING_FLAG:
                break
            COUNTER_PING = COUNTER_PING + 1
            # and then check the response...
        except Exception as GEN_ERR:
            error("Error in ping : " + str(GEN_ERR))
            COUNTER_PING = COUNTER_PING + 1
        debug("Ping took : " + str(abs(CYCLE_PING_TIME - time.time())))
    SLEEP_TIME = SLEEP_TIME - abs(START_PINGTIME - time.time())
    debug("Remaining sleep time is " + str(SLEEP_TIME))
    return "Ping completed"


debug("restarting Script")
while True:
    debug("START of Transaciton")
    RUN_INIT = time.time()
    SUCCESS_FLAG = True
    FAILURE_FLAG = False
    FAIL_WRITE_FLAG = False
    try:
        debug('The count_of_failures is %d' % COUNT_OF_FAILURES)
        KONG_CALL = KONG_COMMAND + ' ' + KONG_URL + '' \
            + str(datetime.now().strftime('%d_%m_%Y_%H_%M_%S_%f'))

        # debug("curl call %s"%kong_call)
        TMP_FILE_GEN = run_on_shell(KONG_CALL + ' &>' + TMP_FILE).strip()
        CURL_DECISION = curl_v_parser(run_on_shell('cat ' + TMP_FILE))
        TOTAL_TIME = RUN_INIT - time.time()
        debug('time taken for curl call %f' % (RUN_INIT - time.time()))

        if CURL_DECISION:
            debug('check_output() is successful')
            SLEEP_TIME = 15
            COUNT_OF_FAILURES = 0
            debug('count_of_failures set/reset to 0')
            FAIL_WRITE_FLAG = False
            #on wdc ping disabled
            #for host in KONG_HOSTS:
                #debug("Trying to ping " + host)
                #ping_maker(host)
            # debug(type(SLEEP_TIME))
        else:
            COUNT_OF_FAILURES = COUNT_OF_FAILURES + 1
            debug('The count_of_failures is %d' % COUNT_OF_FAILURES)
            warning('Change in count_of_failures %d'
                    % COUNT_OF_FAILURES)
            error('Change in count_of_failures %d' % COUNT_OF_FAILURES)
            if COUNT_OF_FAILURES > TOLERANT_COUNT - 1:
                error('Breaching Tolerance')
                FAIL_WRITE_FLAG = True
            # ping_maker(KONG_HOST)
            for host in KONG_HOSTS:
                debug("Trying to ping " + host)
                ping_maker(host)

        if FAIL_WRITE_FLAG:
            debug(
                file_modify(FILE_TO_MODIFY, "success", "failure"))
        else:
            debug(
                file_modify(FILE_TO_MODIFY, "failure", "success"))
        debug('time taken for this run %f' % (RUN_INIT - time.time()))
        debug('time spent in execution %f' %
              (RUN_INIT - time.time() - TOTAL_TIME))
        debug("starting cat  dump ")
        TIME_NOW = time.time()
        run_on_shell("cat %s >> %s" % (TMP_FILE, DUMP_FILE))
        debug('TOTAL time spent in execution %f' % (RUN_INIT - time.time()))
    except Exception as GEN_ERR:
        error('Could not write/update the file' + str(GEN_ERR))
        error(traceback.print_exc())
    try:
        debug("END of  Transaciton, will sleep now for %d" % (SLEEP_TIME))
        debug("Sleep time is " + str(SLEEP_TIME) +
              " type of sleep is " + str(type(SLEEP_TIME)))
        sleep(int(SLEEP_TIME))
    except Exception as e:
        debug("Error in sleep_time try block " + str(e))


