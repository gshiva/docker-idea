#!/bin/bash

FAIL=0

if [ ! -d /home/developer/config ]; then
  mkdir /home/developer/config
fi

if [ ! -d /home/developer/config/.mozilla ]; then
  mkdir /home/developer/config/.mozilla
fi

if [ ! -d /home/developer/config/.idea ]; then
  mkdir /home/developer/config/.idea
fi

if [ ! -d /home/developer/config/.config ]; then
  mkdir /home/developer/config/.config
fi

sudo chown developer:developer /home/developer/config

if [ ! -d /home/developer/.mozilla ]; then
  ln -s /home/developer/config/.mozilla /home/developer/.mozilla
fi

if [ ! -d /home/developer/.idea ]; then
  ln -s /home/developer/config/.idea /home/developer/.idea
fi

if [ ! -d /home/developer/.config ]; then
  ln -s /home/developer/config/.config /home/developer/.config
fi

if [ -d /home/developer/IdeaProjects ]; then
  sudo chown developer:developer /home/developer/IdeaProjects
fi

if [ -d /home/developer/.m2 ]; then
  sudo chown developer:developer /home/developer/.m2
fi

sudo chown developer:developer /home/developer/.idea

if [ ! -f /home/developer/.config/tilda/config_0 ]; then
  if [ ! -d /home/developer/.config/tilda/ ]; then
    mkdir -p /home/developer/.config/tilda/
  fi
  echo "copying tilda config"
  cp /home/template/.config/tilda/config_0 /home/developer/.config/tilda/config_0
else
  echo "tilda: preserving existing config."
fi


echo "starting"

/usr/local/bin/idea &
/usr/bin/firefox -no-remote &
/usr/bin/tilda -c /bin/bash &
TILDA_PID=$!
if [ /home/developer/config/autoexec.sh ]; then 
  /home/developer/config/autoexec.sh
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


