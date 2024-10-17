for I in {1..100}
do
  j=$(( $I % 2 ))
  if [ $j != 0 ]; then
    echo $I
  fi
done
