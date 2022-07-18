#!/bin/bash

#define parameters which are passed in.
NAME=$1; shift
DOMAINLIST=$@

INDVDOMAIN=$(
  for DOMAIN in {$DOMAINLIST}; do
    $LOWER=`echo "$DOMAIN" | sed 's/./\L&/g'`
    echo "    - name: $LOWER"
    echo "      certs:"
    echo "      - certType: usrcerts"
    echo "        secret: $LOWER-cert"
    echo "      dpApp:"
    echo "        config:"
    echo "        - $LOWER-cfg"
    echo "        local:"
    echo "        - $LOWER-local"
  done;
)

#define the template.
cat  << EOF
apiVersion: datapower.ibm.com/v1beta3
kind: DataPowerService
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "350"
  name: $NAME
spec:
  replicas: 1
  version: 10.0-cd
  license:
    accept: true
    use: nonproduction
    license: L-RJON-CCCP46
  users:
  - name: admin
    accessLevel: privileged
    passwordSecret: datapower-user
  domains:
    - name: default
      certs:
      - certType: usrcerts
        secret: default-cert
      dpApp:
        config:
        - default-cfg
        local:
        - default-local
$INDVDOMAIN
EOF
