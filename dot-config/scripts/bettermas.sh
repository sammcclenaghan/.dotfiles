#!/usr/bin/env bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 [--dry-run] <search_term>"
    exit 1
}

# Check if at least one argument is provided
if [[ $# -eq 0 ]]; then
    usage
fi

# Initialize variables
dry_run=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            dry_run=true
            shift
            ;;
        *)
            search_term="$1"
            shift
            ;;
    esac
done

# Check if search term is provided
if [[ -z "$search_term" ]]; then
    usage
fi

# Prompt user to search for an app using 'mas search' and let them select an app via fzf
selected_app=$(mas search "$search_term" | fzf --tmux 50%,40% --prompt="Search for an app to install: " --border)

# Check if user selected an app or canceled
if [[ -z "$selected_app" ]]; then
    echo "No app selected. Exiting."
    exit 1
fi

# Extract the app ID (it's the first column in the selected output)
app_id=$(echo "$selected_app" | awk '{print $1}')

# Check if a valid app ID was found
if [[ -z "$app_id" ]]; then
    echo "No valid app ID found. Exiting."
    exit 1
fi

# Dry run mode
if [[ "$dry_run" == true ]]; then
    echo "Dry run: App with ID $app_id would be installed."
    exit 0
fi

# Install the selected app using 'mas install <app_id>'
echo "Installing app with ID: $app_id"
result=$(mas install "$app_id" 2>&1)

if [[ $? -eq 0 ]]; then
    echo "App installed successfully."
else
    echo "Failed to install app. Error: $result"
fi
