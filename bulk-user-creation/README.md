# Bulk User Creation

This directory contains a Bash script (`create a bulk of users`) that automates the creation of multiple Linux users from a CSV file (expected at `/opt/scripts/users.csv`). 

## Features
- Reads usernames and passwords from a comma-separated values (CSV) file.
- Validates that the script is run with root privileges.
- Skips invalid lines, missing data, and users that already exist.
- Creates the user account, provisions a home directory, and sets the user's password.

## Usage
1. Prepare a `users.csv` file with a header and subsequent lines formatted as `username,password`.
2. Run the script as root:
   ```bash
   sudo ./create\ a\ bulk\ of\ users
   ```
