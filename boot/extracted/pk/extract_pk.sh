#!/bin/sh

# Dump the EFI Signature List containing the single-entry PK
efi-readvar -v PK -o framework_PK.esl
# Convert each entry in that list (the one of them) to a DER cert
sig-list-to-certs framework_PK.esl framework_PK
# Convert each DER (binary) cert to a PEM (Base64 ASCII) cert
for f in framework_PK-*.der; do
  #echo "${f}" "${f%.der}.pem"
  openssl x509 -inform der -in "$f" -outform pem -out "${f%.der}.pem"
done
