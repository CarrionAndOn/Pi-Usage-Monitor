#!/bin/bash

# Create a log file for everything the script is doing
LOG_FILE=$(dirname $0)/install.log
touch $LOG_FILE

# Check if psutil is installed
if ! command -v pip3 &> /dev/null; then
    # Install psutil
    echo 'Installing psutil...'
    sudo apt-get update >> $LOG_FILE 2>&1
    sudo apt-get install python3-pip -y >> $LOG_FILE 2>&1
	# Error handling for if psutil fails to install
    if ! pip3 install psutil >> $LOG_FILE 2>&1; then
        echo 'Failed to install psutil.' >&2
        exit 1
    fi
fi

# Download the usage monitor python script to /home
echo 'Installing script...'
# Error handling for if wget fails to download the script
if ! wget https://raw.githubusercontent.com/CarrionAndOn/Linux-Usage-Monitor/main/usagemonitor.py -P ~/ >> $LOG_FILE 2>&1; then
    echo 'Failed to download the script.' >&2
    exit 1
fi

# Generate a config file
echo 'Config Creation'
touch /opt/usagemonitordiscord/usagemonitor.conf
# Prompt the user for the Discord webhook URL
read -p "Enter the Discord webhook URL: " WEBHOOK_URL
# Add that to the config
echo "Webhook: $WEBHOOK_URL" >> /opt/usagemonitordiscord/usagemonitor.conf
# Prompt the user for the desired time between each message
read -p "Enter the time between each message in seconds: " TIME
# Add that to the config too
echo "Time(Seconds): $TIME" >> /opt/usagemonitordiscord/usagemonitor.conf
# Prompt the user for if they're on a Pi
read -p "Are you using a Raspberry Pi for this? Type 'yes' if you are, anything else if you aren't. CASE SENSITIVE. " SYSTEM
echo "Pi: $SYSTEM" >> /opt/usagemonitordiscord/usagemonitor.conf

# Move script to /opt to run
mkdir /opt/usagemonitordiscord
sudo mv ~/usagemonitor.py /opt/usagemonitordiscord
echo 'Installed to /opt/usagemonitordiscord'

# Create a systemd service for the script
echo 'Creating service...'
cat <<EOF | sudo tee /etc/systemd/system/usagemonitor.service >> $LOG_FILE 2>&1 >/dev/null
[Unit]
Description=Usage Monitor: Discord

[Service]
ExecStart=/usr/bin/python3 /opt/usagemonitordiscod/usagemonitor.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the service
echo 'Pre-fixing any possible issues with systemd...'
sudo systemctl daemon-reexec >> $LOG_FILE 2>&1 >/dev/null
echo 'Reloading systemd...'
sudo systemctl daemon-reload >> $LOG_FILE 2>&1 >/dev/null
echo 'Starting service...'
# Error handling for if the service fails to start.
if ! sudo systemctl start usagemonitor >> $LOG_FILE 2>&1; then
    echo 'Failed to start the service.' >&2
    exit 1
fi
echo 'Setting service to open on startup...'
sudo systemctl enable usagemonitor >> $LOG_FILE 2>&1 >/dev/null
echo 'Installed! Check your discord channel where the webhook was set up.'