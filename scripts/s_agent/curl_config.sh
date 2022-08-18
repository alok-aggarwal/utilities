#!/bin/bash

#evt.time.iso8601, evt.time, evt.type, syscall.type,
#	    evt.category, evt.args, evt.res, evt.failed, proc.pid,
#	    proc.exe, proc.name, proc.args, proc.cmdline, proc.cwd,
#	    proc.ppid, proc.pname, proc.pcmdline, proc.sid, proc.exepath,
#	    user.uid, user.loginuid, user.loginname, user.shell, user.homedir,
#	    user.name, group.gid, group.name, container.id, container.name,
#	    container.image, container.image.repository, container.image.tag
#proc.aname[2], proc.aname[3], proc.aname[4], proc.aname[5], proc.aname[6], proc.aname[7], proc.aname[8], proc.aname[9], proc.aname[10], proc.aname[11], proc.aname[12]
#to send proc.aname and proc.apid fields, you should add an index and configure it like:
#"content": "secure_events_extra_fields: [\"proc.aname[0]\", \"proc.aname[1]\", \"proc.aname[2]\", \"proc.aname[3]\", \"proc.aname[4]\", \"proc.aname[5]\", \"proc.apid[0]\", \"proc.apid[1]\", \"proc.apid[2]\", \"proc.apid[3]\", \"proc.apid[4]\", \"proc.apid[5]\"]"
curl -k --location --request PUT 'https://secure-staging.sysdig.com/api/agents/config' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer 560b2da6-adc8-43be-b388-85ebc48ad180' \
--header 'Cookie: INGRESSCOOKIEAPI=91b18f092bdfbef1' \
--data-raw '{
    "files": [
        {
            "filter": "*",
            "content": "secure_events_extra_fields: []\nsecure_audit_streams:\n  enabled: true\n  enabled_opt:\n    weak: true\nnetwork_topology:\n  enabled: true\n  enabled_opt:\n    weak: true\nfalcobaseline:\n  enabled: true\n  report_interval: 900000000123\naudit_tap:\n  enabled: false"
        }
    ]
}'
