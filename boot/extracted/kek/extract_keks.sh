#!/bin/sh

# Dump the EFI Signature List containing the single-entry PK
efi-readvar -v KEK -o framework_KEK.esl
# Convert each entry in that list to a DER cert
sig-list-to-certs framework_KEK.esl framework_KEK
# Convert each DER (binary) cert to a PEM (Base64 ASCII) cert
for f in framework_KEK-*.der; do
  #echo "${f}" "${f%.der}.pem"
  openssl x509 -inform der -in "$f" -outform pem -out "${f%.der}.pem"
done
