#!/usr/bin/env bash

# Prompt user to search for an app using 'mas search' and let them select an app via fzf
selected_app=$(mas search "$1" | fzf --preview "echo {}" --preview-window=up:1:wrap)

# Check if user selected an app or canceled
if [[ -z "$selected_app" ]]; then
  echo "No app selected. Exiting."
  exit 1
fi

# Extract the app ID (it's the first column in the selected output)
app_id=$(echo "$selected_app" | awk '{print $1}')

# Install the selected app using 'mas install <app_id>'
echo "Installing app with ID: $app_id"
mas install "$app_id"

