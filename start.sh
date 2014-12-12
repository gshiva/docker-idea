#!/bin/bash

FAIL=0

echo "starting"

/usr/local/bin/netbeans &
/usr/bin/firefox -no-remote &
/usr/bin/tilda &
TILDA_PID=$!

for job in `jobs -p | grep -v $TILDA_PID`
do
echo $job
    wait $job || let "FAIL+=1"
done

echo $FAIL

if [ "$FAIL" == "0" ];
then
echo "BYE"
else
echo "FAIL! ($FAIL)"
fi


