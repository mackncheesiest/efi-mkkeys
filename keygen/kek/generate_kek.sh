#!/bin/sh

set -x;

if [ ! -e /etc/EFI/sbkeys/my_keys/pk/PK.pem ]; then
  echo "PK hasn't been generated yet, go do that first as it's used as the CA for issuing the KEK!" >&2
  exit 1
fi

echo "Generating KEK private key and public cert"

# Generate new private key and public cert
# Use the PK as the CA
openssl req -new -x509 \
	-CA /etc/EFI/sbkeys/my_keys/pk/PK.pem \
	-CAkey /etc/EFI/sbkeys/my_keys/pk/PK.key \
	-subj "/CN=beanie-LaptopKEK/" \
	-newkey rsa:4096 \
	-keyout KEK.key \
	-out KEK.pem \
	-days 36500 \
	-noenc

echo "Converting this new cert to a singleton signature list for merging with stock keys"

# Generate the ESL that we'll be merging in
cert-to-efi-sig-list -g "$(< /etc/EFI/sbkeys/my_keys/GUID.txt)" KEK.pem KEK.esl

cat <<EOF
Done!

Now go regenerate the DB keys using the KEK as CA
EOF
