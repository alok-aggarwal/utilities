#!/bin/bash

HOSTNAME=`/bin/hostname`
EPOCH=`/bin/date +%s`
PATH=${1}
DEST=${PATH}

command_exists() {
        command -v "$@" > /dev/null 2>&1
}

if [ -z ${PATH} ]; then
	PATH="/tmp/bundle-${HOSTNAME}-${EPOCH}.log"
	DEST="/tmp/bundle-${HOSTNAME}-${EPOCH}.tgz"
else
	PATH+="/bundle-${HOSTNAME}-${EPOCH}.log"
	DEST+="/bundle-${HOSTNAME}-${EPOCH}.tgz"
fi
SUDO=''
if (( $EUID != 0 )); then
    SUDO='/usr/bin/$SUDO'
fi
echo "======= LOGGER VERSION: 5th May 2019 12:10 PM PST ===========" >${PATH}
echo "======= LOGGER RUN ON: `/bin/date` ===========" >${PATH}
echo "======= UNAME: `/bin/uname -a` ===========" >>${PATH}
echo "======= HOST: ${HOSTNAME} ===========" >>${PATH}
echo "======= UPTIME: `/usr/bin/uptime` ===========" >>${PATH}
echo "======= TOP DATA ===========" >>${PATH}
$SUDO /usr/bin/top -n5 -b >> ${PATH}
echo "======= DF DATA ===========" >>${PATH}
$SUDO /bin/df -al >> ${PATH}
echo "======= MOUNT DATA ===========" >>${PATH}
$SUDO /bin/mount >> ${PATH}
echo "======= IFCFG DATA ===========" >>${PATH}
$SUDO /sbin/ifconfig >> ${PATH}
echo "======= ROUTE DATA ===========" >>${PATH}
$SUDO /bin/cat /proc/net/route >> ${PATH}
echo "======= LSMOD DATA ===========" >>${PATH}
$SUDO /sbin/lsmod >> ${PATH}
echo "======= MACHINE ID DATA ===========" >>${PATH}
$SUDO /bin/cat /var/lib/dbus/machine-id >> ${PATH}
echo "======= PRODUCT UUID DATA ===========" >>${PATH}
$SUDO /bin/cat /sys/devices/virtual/dmi/id/product_uuid >> ${PATH}
echo "======= BOOT ID DATA ===========" >>${PATH}
$SUDO /bin/cat /proc/sys/kernel/random/boot_id >> ${PATH}
echo "======= PS DATA ===========" >>${PATH}
$SUDO /bin/ps -auxwwwf >> ${PATH}
if [ -x /usr/bin/pstree ]; then
	echo "======= PSTREE DATA ===========" >>${PATH}
	$SUDO /usr/bin/pstree >> ${PATH}
fi
if [ -x /bin/journalctl ]; then
	echo "======= JOURNAL DATA ===========" >>${PATH}
	$SUDO /bin/journalctl --all >> ${PATH}
fi
if [ -x /bin/systemctl ]; then
	echo "======= SYSTEMCTL DATA ===========" >>${PATH}
	$SUDO /bin/systemctl --all >> ${PATH}
	$SUDO /bin/systemctl --all list-unit-files >> ${PATH}
	$SUDO /bin/systemctl show >> ${PATH}
fi
if [ -f /var/log/syslog ]; then
	echo "======= SYSLOG DATA ===========" >>${PATH}
	$SUDO /bin/cat /var/log/syslog >> ${PATH}
fi
if [ -f /var/log/syslog.1 ]; then
	echo "======= SYSLOG1 DATA ===========" >>${PATH}
	$SUDO /bin/cat /var/log/syslog.1 >> ${PATH}
fi

if [ -f /var/log/kern.log ]; then
	echo "======= KERNLOG DATA ===========" >>${PATH}
	$SUDO /bin/cat /var/log/kern.log >> ${PATH}
fi
if [ -f /var/log/kern.log.1 ]; then
	echo "======= KERNLOG1 DATA ===========" >>${PATH}
	$SUDO /bin/cat /var/log/kern.log.1 >> ${PATH}
fi
if [ -f /var/log/udev ]; then
	echo "======= UDEV DATA ===========" >>${PATH}
	$SUDO /bin/cat /var/log/udev >> ${PATH}
fi
echo "======= LSOF DATA ===========" >>${PATH}
if [ -x /usr/sbin/lsof ]; then
	$SUDO /usr/sbin/lsof -b +M -n -l -P >> ${PATH}
else
	$SUDO /usr/bin/lsof -b +M -n -l -P >> ${PATH}
fi
echo "======= LDCONFIG DATA ===========" >>${PATH}
$SUDO /sbin/ldconfig -p -N -X >>${PATH}
echo "======= FREE DATA ===========" >>${PATH}
$SUDO /usr/bin/free -m >>${PATH}
echo "======= NETSTAT DATA ===========" >>${PATH}
$SUDO /bin/netstat -anlp >> ${PATH}
echo "======= LISTEN TCP SOCKET DATA ===========" >>${PATH}
for i in `$SUDO /bin/netstat -ltp | /bin/grep -v "Recv-Q\|Active Internet connections" | /usr/bin/tr '/' ' ' | /usr/bin/awk '{print $7}'`; do echo "======" >>${PATH}; $SUDO /bin/ls -latr /proc/$i/exe >>${PATH}; $SUDO /bin/ls -latr /proc/$i/cwd >>${PATH}; $SUDO /bin/ls -latr /proc/$i/fd >>${PATH}; $SUDO /bin/ls -latr /proc/$i/task >>${PATH}; $SUDO /bin/cat /proc/$i/task/$i/children >>${PATH}; done
echo "======= LISTEN UDP SOCKET DATA ===========" >>${PATH}
for i in `$SUDO /bin/netstat -lup | /bin/grep -v "Recv-Q\|Active Internet connections" | /usr/bin/tr '/' ' ' | /usr/bin/awk '{print $6}'`; do echo "======" >>${PATH}; $SUDO /bin/ls -latr /proc/$i/exe >>${PATH}; $SUDO /bin/ls -latr /proc/$i/cwd >>${PATH}; $SUDO /bin/ls -latr /proc/$i/fd >>${PATH}; $SUDO /bin/ls -latr /proc/$i/task >>${PATH}; $SUDO /bin/cat /proc/$i/task/$i/children >>${PATH}; done
echo "======= LW LS DATA ===========" >>${PATH}
$SUDO /bin/ls -latrR /var/lib/lacework >> ${PATH}
$SUDO /bin/ls -latrR /var/log/lacework >> ${PATH}
echo "======= LW STATE DATA ===========" >>${PATH}
$SUDO /usr/bin/stat /var/lib/lacework/collector/state.json >> ${PATH}
$SUDO /bin/cat /var/lib/lacework/collector/state.json >> ${PATH}
echo "======= LW CFG DATA ===========" >>${PATH}
$SUDO /usr/bin/stat /var/lib/lacework/config/config.json >> ${PATH}
$SUDO /bin/cat /var/lib/lacework/config/config.json >> ${PATH}
echo "======= LW INTERNAL STATE DATA ===========" >>${PATH}
if [ -x /bin/pidof ]; then
for i in `/bin/pidof datacollector`; do /bin/cat /proc/$i/cmdline | /bin/grep -a "\-r=collector"; if [ $? -eq 0 ]; then $SUDO kill -SIGQUIT $i; fi; done
fi
echo "======= LW LOG DATA ===========" >>${PATH}
for i in `$SUDO /bin/ls -X /var/log/lacework`; do 
	echo "======= LW $i DATA ===========" >>${PATH}
	$SUDO /bin/cat /var/log/lacework/$i >> ${PATH}
done
echo "======= LW STAT DATA ===========" >>${PATH}
for i in `$SUDO /usr/bin/find /var/lib/lacework -type f | /usr/bin/xargs /bin/ls`; do $SUDO /usr/bin/stat $i >> ${PATH}; done
echo "======= LW PROC-KERNEL DATA ===========" >>${PATH}
for j in `/bin/pidof datacollector`; do for i in `/bin/ls -X /proc/$j/task/`; do ${SUDO} /bin/cat /proc/$j/task/$i/wchan >> ${PATH}; echo ":$j:$i" >> ${PATH};done; done
echo "======= EOF ===============" >>${PATH}
if [ -x /usr/bin/gzip ]; then
	${SUDO} /usr/bin/gzip ${PATH}
else
	${SUDO} /bin/gzip ${PATH}
fi
/bin/ls -latr ${PATH}*
echo "All done, please email the file $PATH.gz"

