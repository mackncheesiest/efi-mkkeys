#!/bin/sh

if [ ! -f ./framework_PK-0.pem ]; then
  echo "Extract PK before running" >&2 
  exit 1
fi

openssl x509 -inform pem -in framework_PK-0.pem -text -noout
