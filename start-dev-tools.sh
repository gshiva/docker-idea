#!/bin/bash

FAIL=0

if [ ! -f /home/user/.config/tilda/config_0 ]; then
  if [ ! -d /home/user/.config/tilda/ ]; then
    mkdir -p /home/user/.config/tilda/
  fi
  echo "copying tilda config"
  cp /home/template/.config/tilda/config_0 /home/user/.config/tilda/config_0
else
  echo "tilda: preserving existing config."
fi


echo "starting"

/usr/local/bin/netbeans -J-Xmx3g&
/usr/bin/firefox -no-remote &
/usr/bin/tilda -c /bin/bash &
TILDA_PID=$!
if [ /home/user/config/autoexec.sh ]; then 
  /home/user/config/autoexec.sh
fi
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


