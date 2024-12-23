# Monitoring scripts
Some scripts to monitor some events, to be used with uptime-kuma and discord push notifs.

Put all of these under 
```
/opt/monitoring/scripts
```
set the right permissions and add them to the crontab 
```bash
@reboot /opt/monitoring/scripts/ssh-monitor.sh > /var/log/monitors/ssh-monitor.log 2>&1
@reboot /opt/monitoring/scripts/syslog-monitor.sh > /var/log/monitors/syslog-monitor.log 2>&1
@reboot /opt/monitoring/scripts/rkhunter-notify.sh > /var/log/monitors/rkhunter-monitor.log 2>&1
@reboot /opt/monitoring/scripts/logwatch-notify.sh > /var/log/monitors/logwatch-monitor.log 2>&1
```
