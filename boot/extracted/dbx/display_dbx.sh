#!/bin/sh

for f in ./framework_dbx-*.pem; do
  echo ""
  echo "Viewing certificate: ${f}"
  echo ""
  openssl x509 -inform pem -in "${f}" -text -noout
done
