#!/bin/bash

# Create a log file for everything the script is doing
LOG_FILE=$(dirname $0)/install.log
touch $LOG_FILE

# Check if psutil is installed
if ! command -v pip3 &> /dev/null
then
    # Install psutil
	echo Installing psutil...
    sudo apt-get update >> $LOG_FILE 2>&1 >/dev/null
    sudo apt-get install python3-pip -y >> $LOG_FILE 2>&1 >/dev/null
    pip3 install psutil >> $LOG_FILE 2>&1 >/dev/null
fi

# Download the usage monitor python script to /home
echo Installing script...
wget https://raw.githubusercontent.com/CarrionAndOn/Linux-Usage-Monitor/main/usagemonitor.py -P /home >> $LOG_FILE 2>&1 >/dev/null

# Prompt the user for the Discord webhook URL
read -p "Enter the Discord webhook URL: " WEBHOOK_URL

# Replace the webhook URL in the usagemonitor.py script with the user's input
sed -i "s|https://discord.com/api/webhooks/WEBHOOK_ID/WEBHOOK_TOKEN|$WEBHOOK_URL|g" /home/usagemonitor.py >> $LOG_FILE 2>&1 >/dev/null

# Create a systemd service for the script
echo Creating service...
cat <<EOF | sudo tee /etc/systemd/system/usagemonitor.service >> $LOG_FILE 2>&1 >/dev/null
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
echo Enabling service...
sudo systemctl daemon-reload >> $LOG_FILE 2>&1 >/dev/null
sudo systemctl start usagemonitor >> $LOG_FILE 2>&1 >/dev/null
sudo systemctl enable usagemonitor >> $LOG_FILE 2>&1 >/dev/null
echo Installed! Check your discord channel where the webhook was set up.
set +x