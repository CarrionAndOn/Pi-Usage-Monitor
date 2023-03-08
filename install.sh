#!/bin/bash

# Check if psutil is installed
if ! command -v pip3 &> /dev/null
then
    # Install psutil
    sudo apt-get update
    sudo apt-get install python3-pip -y
    pip3 install psutil
fi

# Download the usage monitor python script to /home
wget https://cdn.carrionandon.me/assets/usagemonitor.py -P /home

# Prompt the user for the Discord webhook URL
read -p "Enter the Discord webhook URL: " WEBHOOK_URL

# Replace the webhook URL in the usagemonitor.py script with the user's input
sed -i "s|https://discord.com/api/webhooks/WEBHOOK_ID/WEBHOOK_TOKEN|$WEBHOOK_URL|g" /home/usagemonitor.py

# Create a systemd service for the script
cat <<EOF | sudo tee /etc/systemd/system/usagemonitor.service
[Unit]
Description=Usage Monitor Service

[Service]
Type=simple
ExecStart=/usr/bin/python3 /home/usagemonitor.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the service
sudo systemctl daemon-reload
sudo systemctl start usagemonitor
sudo systemctl enable usagemonitor
