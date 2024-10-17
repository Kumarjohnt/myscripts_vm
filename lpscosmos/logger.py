import sys,os
import logging
from logging import DEBUG, INFO, ERROR

class MyLogger():

    def __init__(self, name,  format="%(asctime)s [%(levelname)s] %(message)s",level=INFO):
        logFilePath = r"/tmp/cmcli/"
        chkdir = os.path.isdir(logFilePath)
        if not chkdir:
            os.makedirs(logFilePath, mode=0o775)
            # os.chown(logFilePath, apache)
        # Initial construct.
        self.format = format
        self.level = level
        self.name = name

        # Logger configuration.
        self.fmtr = logging.Formatter("%(asctime)s [%(levelname)s] %(message)s", datefmt="%m/%d/%Y %I:%M:%S %p")
        self.console_formatter = logging.Formatter(self.format)
        self.console_logger = logging.StreamHandler(sys.stdout)
        self.console_logger.setFormatter(self.console_formatter)
        self.file_logger = logging.FileHandler(logFilePath+'/'+ name + ".log")
        self.file_logger.setFormatter(self.fmtr)

        # Complete logging config.
        self.logger = logging.getLogger(name)
        self.logger.setLevel(self.level)
        self.logger.addHandler(self.file_logger)

    def info(self, msg, extra=None):
        self.logger.info(msg, extra=extra)

    def error(self, msg, extra=None):
        self.logger.error(msg, extra=extra)

    def debug(self, msg, extra=None):
        self.logger.debug(msg, extra=extra)

    def warn(self, msg, extra=None):
        self.logger.warn(msg, extra=extra)

if __name__ == '__main__':
    print(logFilePath)

