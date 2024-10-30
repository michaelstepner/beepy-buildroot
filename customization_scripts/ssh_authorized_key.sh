#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide an SSH public key."
  exit 1
fi

# Configure SSH authorized key for beepy user
echo "$1" > root_overlay/etc/skel/authorized_keys
chmod 600 root_overlay/etc/skel/authorized_keys

cat << 'EOC' >> post-build.sh

# Disable password login for SSH
cat << 'EOF' >> ${TARGET_DIR}/etc/ssh/sshd_config

# Only allow public key authentication
PasswordAuthentication      no
PermitEmptyPasswords      no
ChallengeResponseAuthentication      no
UsePAM      no
PermitRootLogin      no
PubkeyAuthentication      yes

EOF
EOC
