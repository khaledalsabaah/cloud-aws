#!/bin/bash

# Navigate to the home directory
cd /home/ec2-user || exit

# Update the system and install Python3 and pip
yes | sudo yum update -y
yes | sudo yum install -y python3 python3-pip git

# Clone the GitHub repository
git clone https://github.com/Skyphoenixx/PythonFlaskApi.git
sleep 20

# Navigate to the cloned repository directory
cd PythonFlaskApi

# Install dependencies from requirements.txt
pip3 install -r requirements.txt

# Wait for a short duration before running the application
sleep 10
echo 'Waiting for 30 seconds before running app.py'

# Run the application
python3 -u app.py
sleep 30