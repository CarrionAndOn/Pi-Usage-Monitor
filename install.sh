#!/bin/bash

# Create a log file for everything the script is doing
LOG_FILE=$(dirname $0)/install.log
touch $LOG_FILE

# Check if psutil is installed
if ! command -v pip3 &> /dev/null
then
    # Install psutil
	echo 'Installing psutil...'
    sudo apt-get update >> $LOG_FILE 2>&1 >/dev/null
    sudo apt-get install python3-pip -y >> $LOG_FILE 2>&1 >/dev/null
    pip3 install psutil >> $LOG_FILE 2>&1 >/dev/null
fi

# Download the usage monitor python script to /home
echo 'Installing script...'
wget https://raw.githubusercontent.com/CarrionAndOn/Linux-Usage-Monitor/main/usagemonitor.py -P ~/ >> $LOG_FILE 2>&1 >/dev/null

# Generate a config file
echo 'Config Creation'
touch /opt/usagemonitor.conf
# Prompt the user for the Discord webhook URL
read -p "Enter the Discord webhook URL: " WEBHOOK_URL
# Add that to the config
echo "Webhook: $WEBHOOK_URL" >> /opt/usagemonitor.conf
# Prompt the user for the desired time between each message
read -p "Enter the time between each message in seconds: " TIME
# Add that to the config too
echo "Time(Seconds): $TIME" >> /opt/usagemonitor.conf
# Prompt the user for if they're on a Pi
read -p "Are you using a Raspberry Pi for this? Type 'yes' if you are, anything else if you aren't. CASE SENSITIVE." SYSTEM
echo "Pi: $SYSTEM" >> /opt/usagemonitor.conf

# Move script to /opt to run
sudo mv ~/usagemonitor.py /opt/
echo 'Installed to /opt/'

# Create a systemd service for the script
echo 'Creating service...'
cat <<EOF | sudo tee /etc/systemd/system/usagemonitor.service >> $LOG_FILE 2>&1 >/dev/null
[Unit]
Description=Usage Monitor: Discord

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/usagemonitor.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the service
echo 'Enabling service...'
sudo systemctl daemon-reload >> $LOG_FILE 2>&1 >/dev/null
sudo systemctl start usagemonitor >> $LOG_FILE 2>&1 >/dev/null
sudo systemctl enable usagemonitor >> $LOG_FILE 2>&1 >/dev/null
echo 'Installed! Check your discord channel where the webhook was set up.'