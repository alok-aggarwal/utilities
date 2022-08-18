#!/bin/bash

curl -k --location --request GET 'https://ec2-54-144-17-47.compute-1.amazonaws.com/api/v1/secureEvents/topStats?filter=not source in ("auditTrail") and severity in ("0","1","2","3","4","5","6") and originator in ("compliance")&from=1657175793000000000&rows=5&to=1657262193000000000' \
--header 'X-Sysdig-Product: SDS' \
--header 'Authorization: Bearer 21b02859-f060-42c3-8a00-b9b46dc3652f'
