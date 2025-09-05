#!/bin/bash

# Navigate to /src
cd src

# Config scripts for running
chmod +x clone.sh deploy.sh get-ip.sh

# Run the first script
./clone.sh

# Run the script to get the ip address
./get-ip.sh

# Run the second script
./deploy.sh
