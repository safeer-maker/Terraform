#bin/bash

# Install the required packages
#source ./bin/terradorm-cli

# loading the environment variables
#source ./bin/environment-var

if [ -f "./bin/environment-var" ]; then
  source ./bin/environment-var
  echo "environment-var. COMPLETE"
  echo $MY_VAR
else
  echo "Error: environment-var file not found."
fi
