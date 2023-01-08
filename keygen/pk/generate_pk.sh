#!/bin/sh

set -x;

echo "Generating PK private key and public cert + noPK.auth"

# Generate new private key and public cert
openssl req -new -x509 \
	-subj "/CN=beanie-LaptopPK/" \
	-newkey rsa:4096 \
	-keyout PK.key \
	-out PK.pem \
	-days 36500 \
	-noenc

# Create a noPK.auth
# Enrolling this while in user mode allows clearing the PK without clearing all the other KEK/DB/DBX/etc EFI variables
sign-efi-sig-list -g "$(< /etc/EFI/sbkeys/my_keys/GUID.txt)" -c ./PK.pem -k ./PK.key PK /dev/null noPK.auth

echo "Converting new PK cert to a singleton signature list"

# Generate the ESL that we'll be merging in
cert-to-efi-sig-list -g "$(< /etc/EFI/sbkeys/my_keys/GUID.txt)" PK.pem PK.esl

cat <<EOF
Done!

Now go regenerate the KEK keys using the PK as CA
EOF
