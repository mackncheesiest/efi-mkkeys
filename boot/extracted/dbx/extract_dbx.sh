#!/bin/sh

# Dump the EFI Signature List containing the single-entry PK
efi-readvar -v dbx -o framework_dbx.esl
# Convert each entry in that list to a .hash binary file
sig-list-to-certs framework_dbx.esl framework_dbx
