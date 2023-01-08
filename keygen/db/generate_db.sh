#!/bin/sh

set -x;

if [ ! -e /etc/EFI/sbkeys/my_keys/kek/KEK.pem ]; then
  echo "KEK hasn't been generated yet, go do that first as it's used as the CA for issuing the DB!" >&2
  exit 1
fi

echo "Generating DB private key and public cert"

# Generate new private key and public cert
# Use the KEK as the CA
openssl req -new -x509 \
	-CA /etc/EFI/sbkeys/my_keys/kek/KEK.pem \
	-CAkey /etc/EFI/sbkeys/my_keys/kek/KEK.key \
	-subj "/CN=beanie-LaptopDB/" \
	-newkey rsa:4096 \
	-keyout DB.key \
	-out DB.pem \
	-days 36500 \
	-noenc

echo "Converting this new cert to a singleton signature list for merging with stock keys"

# Generate the ESL that we'll be merging in
cert-to-efi-sig-list -g "$(< /etc/EFI/sbkeys/my_keys/GUID.txt)" DB.pem DB.esl

cat <<EOF
Done!

Now go merge these new ESLs with the stock ones, sign them, and get them enrolled! (over in /boot/efi/sbkeys/combined_lists)
EOF
