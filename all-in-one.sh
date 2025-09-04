#!/bin/bash

# Navigate to /src
cd /src

# Config scripts for running
chmod 600 clone.sh deploy.sh

# Run the first script
./clone.sh

# Run the second script
./deploy.sh
