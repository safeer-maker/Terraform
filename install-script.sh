#bin/bash

# Install the required packages
./bin/terradorm-cli

# Install AWS CLI
./bin/aws-cli

# Check if the environment-var file exists
# if [ -f "./bin/environment-var" ]; then
#   source /bin/environment-var
#   echo "environment-var. COMPLETE"
#   echo $MY_VAR
# else
#   echo "Error: environment-var file not found."
# fi
