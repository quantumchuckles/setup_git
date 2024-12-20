# Setup SSH and Git Configuration Script

This script automates the setup of SSH authentication, GPG signing, and Git configuration. It ensures your SSH and Git environment is properly configured for authentication with GitHub or other Git services.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Customization](#customization)
- [How to Run the Script](#how-to-run-the-script)
- [Automating the GitHub SSH Setup](#automating-the-github-ssh-setup)
- [Additional Notes](#additional-notes)

## Features

- **Automates SSH key generation** using the `ed25519` algorithm.
- **Automatically configures Git with your username and email**.
- **Enables GPG signing for commits and tags**.
- **Handles existing SSH keys with options to delete or backup**.
- **Configures Git to use GPG for signing commits and tags**.
- **Uses SSH for authentication with GitHub**.

## Prerequisites

Before running the script, make sure you have the following installed on your machine:

- `git`
- `ssh`
- `ssh-agent`

You can install these using your package manager (e.g., `apt-get`, `brew`, etc.).

### Example:

- **On Ubuntu/Debian**: `sudo apt-get install git ssh gpg`
- **On macOS (using Homebrew)**: `brew install git ssh gpg`

## Usage

To use the script:

1. **Clone this Repository**: Clone this repository or download the `setup_ssh_auth.sh` script.
2. **Modify the Script (optional)**: Customize email and username variables within the script if needed.
3. **Run the Script**: Execute the script in your terminal with the following command:

   ```bash
   ./setup_ssh_auth.sh
   ```

4. **Follow the prompts**:
   - The script will ask whether you want to delete existing SSH keys or create a backup.
   - Enter your email and username for Git configuration.
   - Confirm the GitHub SSH key prompt (automatically adds GitHub's SSH key to known hosts).

## Customization

To customize the script:

- Edit the `EMAIL` and `USERNAME` variables at the beginning of the script (`setup_ssh_auth.sh`).
- Modify the key generation parameters (`ssh-keygen -t ed25519` is used).
- Adjust configurations such as `git` user settings or GPG key settings as needed.

## How to Run the Script

To run the script, make sure it is executable:

```bash
chmod +x setup_ssh_auth.sh
```

Then run:

```bash
./setup_ssh_auth.sh
```

This script will guide you through the process and provide options to manage your SSH and Git configurations.

## Automating the GitHub SSH Setup

The script includes automated steps to handle GitHub SSH key authentication:

- It will automatically add GitHub's SSH key to the `~/.ssh/known_hosts`.
- It will test the connection using `ssh -T git@github.com`.
- Handle SSH fingerprint verification automatically.

## Additional Notes

- The script creates backups of existing SSH configurations if requested.
- Ensure your system has the necessary tools (git, ssh, ssh-agent, gpg).
- If you encounter issues with GitHub connection prompts (e.g., unknown host), make sure `ssh-keyscan` has successfully added GitHub’s SSH key fingerprint.

## Contributing

If you would like to contribute to this script, please fork the repository and submit a pull request with any improvements or bug fixes.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
