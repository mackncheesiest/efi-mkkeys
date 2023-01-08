#!/bin/sh
set -x

# No merging PKs, there's only one PK
cat /etc/EFI/sbkeys/my_keys/pk/PK.esl > merged_PK.esl
# Merge framework KEKs with my KEK
cat /boot/efi/sbkeys/stock_framework/kek/framework_KEK.esl /etc/EFI/sbkeys/my_keys/kek/KEK.esl > merged_KEK.esl
# Merge framework DBs with my DB
cat /boot/efi/sbkeys/stock_framework/db/framework_db.esl /etc/EFI/sbkeys/my_keys/db/DB.esl > merged_DB.esl
# I don't have any other DBX hashes to incorporate
cat /boot/efi/sbkeys/stock_framework/dbx/framework_dbx.esl > merged_dbx.esl

# Self-sign PK
sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:S')" \
		  -g "$(cat /etc/EFI/sbkeys/my_keys/GUID.txt)" \
		  -c /etc/EFI/sbkeys/my_keys/pk/PK.pem -k /etc/EFI/sbkeys/my_keys/pk/PK.key PK merged_PK.esl merged_PK.auth
# Sign KEK with PK
sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:S')" \
		  -g "$(cat /etc/EFI/sbkeys/my_keys/GUID.txt)" \
		  -c /etc/EFI/sbkeys/my_keys/pk/PK.pem -k /etc/EFI/sbkeys/my_keys/pk/PK.key KEK merged_KEK.esl merged_KEK.auth
# Sign DB with KEK
sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:S')" \
		  -g "$(cat /etc/EFI/sbkeys/my_keys/GUID.txt)" \
		  -c /etc/EFI/sbkeys/my_keys/kek/KEK.pem -k /etc/EFI/sbkeys/my_keys/kek/KEK.key db merged_DB.esl merged_DB.auth

# Copy the public key certs over for good measure
# cp /etc/EFI/sbkeys/my_keys/pk/PK.pem PK.crt
# cp /etc/EFI/sbkeys/my_keys/kek/KEK.pem KEK.crt
# cp /etc/EFI/sbkeys/my_keys/db/DB.pem DB.crt

# Sign KeyTool.efi with the DB key
sbsign --key /etc/EFI/sbkeys/my_keys/db/DB.key --cert /etc/EFI/sbkeys/my_keys/db/DB.pem --output /boot/efi/EFI/efitools/KeyTool-signed-personal.efi /usr/share/efitools/efi/KeyTool.efi

# Add the boot entry for KeyTool-signed-personal
efibootmgr --create --disk /dev/nvme0n1p1 --loader /EFI/efitools/KeyTool-signed-personal.efi "KeyTool" --label "KeyTool" --unicode

echo <<EOF
Done!

Now go clear SecureBoot settings and enroll with KeyTool-signed-personal.efi
EOF

