#!/bin/sh

# Dump the EFI Signature List containing the single-entry PK
efi-readvar -v db -o framework_db.esl
# Convert each entry in that list to a DER cert
sig-list-to-certs framework_db.esl framework_db
# Convert each DER (binary) cert to a PEM (Base64 ASCII) cert
for f in framework_db-*.der; do
  #echo "${f}" "${f%.der}.pem"
  openssl x509 -inform der -in "$f" -outform pem -out "${f%.der}.pem"
done
