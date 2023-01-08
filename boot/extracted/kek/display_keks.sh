#!/bin/sh

for f in ./framework_KEK-*.pem; do
  echo ""
  echo "Viewing certificate: ${f}"
  echo ""
  openssl x509 -inform pem -in "${f}" -text -noout
done
