#!/bin/bash

# Update the system
sudo yum update -y

# Install Python3 and Pip
sudo yum install python3 -y
sudo yum install python3-pip -y

# Create a virtual environment
python3 -m venv myenv
source myenv/bin/activate

# Install Flask
pip install Flask