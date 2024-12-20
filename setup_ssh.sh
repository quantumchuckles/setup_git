#!/bin/bash

# Function to check if a program is installed
function check_program {
  if ! command -v "$1" &> /dev/null
  then
    echo "$1 is not installed. Please install it and try again."
    exit 1
  fi
}

# Check for necessary programs
check_program "git"
check_program "ssh"
check_program "ssh-agent"
check_program "gpg"

# Function to display existing keys
function show_existing_keys {
  echo "Existing SSH Keys:"
  ls -al ~/.ssh/*.pub 2>/dev/null || echo "No SSH keys found."

  echo -e "\nExisting GPG Keys:"
  gpg --list-keys 2>/dev/null || echo "No GPG keys found."

  echo -e "\nExisting Git Configuration:"
  git config --list || echo "No Git configuration found."
}

# Prompt user for actions
echo "Do you want to delete existing SSH keys or create a backup? (delete/backup)"
read ACTION

if [ "$ACTION" == "delete" ]; then
  echo "Deleting existing keys..."
  rm -rf ~/.ssh
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  ssh-add -D

  rm -rf ~/.gnupg
  rm -rf ~/.gitconfig
  touch ~/.gitconfig
elif [ "$ACTION" == "backup" ]; then
  # Backup existing SSH keys
  if [ -d ~/.ssh ]; then
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    echo "Backing up existing SSH keys to ~/.ssh_backup_$TIMESTAMP..."
    cp -r ~/.ssh ~/.ssh_backup_$TIMESTAMP
    echo "Backup completed at ~/.ssh_backup_$TIMESTAMP."
  else
    echo "No existing SSH keys found to backup."
  fi
else
  echo "Invalid choice. Please choose 'delete' or 'backup'."
  exit 1
fi

# Prompt for email and username
echo "Enter your email:"
read EMAIL

echo "Enter your username:"
read USERNAME

# Generate a new SSH key
echo "Generating a new SSH key..."
ssh-keygen -t ed25519 -C "$EMAIL"

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Automatically add GitHub's SSH key to known_hosts to avoid the yes/no prompt
echo "Adding GitHub's SSH key to known_hosts..."
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Test SSH connection
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com

# Set up Git configuration
echo "Configuring Git..."
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"
git config --global commit.gpgSign true
git config --global tag.gpgSign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# Configure allowed signers for GPG
mkdir -p ~/.gnupg
echo "$(git config --get user.email) namespaces=\"git\" $(cat ~/.ssh/id_ed25519.pub)" >> ~/.gnupg/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.gnupg/allowed_signers

echo "Setup complete!"
