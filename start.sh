#!/bin/bash

FAIL=0

if [ ! -d /home/developer/config ]; then
  mkdir /home/developer/config
fi

if [ ! -d /home/developer/config/.mozilla ]; then
  mkdir /home/developer/config/.mozilla
fi

if [ ! -d /home/developer/config/.netbeans ]; then
  mkdir /home/developer/config/.netbeans
fi

if [ ! -d /home/developer/config/.config ]; then
  mkdir /home/developer/config/.config
fi

sudo chown developer:developer /home/developer/config

if [ ! -d /home/developer/.mozilla ]; then
  ln -s /home/developer/config/.mozilla /home/developer/.mozilla
fi

if [ ! -d /home/developer/.netbeans ]; then
  ln -s /home/developer/config/.netbeans /home/developer/.netbeans
fi

if [ ! -d /home/developer/.config ]; then
  ln -s /home/developer/config/.config /home/developer/.config
fi

if [ -d /home/developer/NetBeansProjects ]; then
  sudo chown developer:developer /home/developer/NetBeansProjects
fi

sudo chown developer:developer /home/developer/.netbeans

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

/usr/local/bin/netbeans &
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


