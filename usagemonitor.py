import subprocess
import re
import requests
import json
import time
import psutil
import os

# Set the config file path and get it's values
config_file_path = "/opt/usagemonitordiscord/config"
webhook_url = config_data.split("Webhook: ")[1].split("\n")[0]
time_seconds = int(config_data.split("Time(Seconds): ")[1].split("\n")[0])

# Get the temperature and capture the output
output = subprocess.check_output(['vcgencmd', 'measure_temp']).decode('utf-8')

# Extract the temperature value from the output using a regular expression
temperature = re.findall(r'\d+\.\d+', output)[0]

# Get CPU usage
cpu_usage = psutil.cpu_percent()

# Get RAM usage
ram = psutil.virtual_memory()
total_ram = round(ram.total / (1024.0 ** 3), 2)
used_ram = round(ram.used / (1024.0 ** 3), 2)

# Build the message to send to the Discord webhook
message = f"Temp: {temperature}°C\nRAM: {used_ram} GB used of {total_ram} GB\nCPU: {cpu_usage}%"

# Define the Discord webhook URL
webhook_url = "{webhook_url}"

# Build the payload to send to the webhook
payload = {
    "content": message
}

# Send the message to the Discord webhook
response = requests.post(webhook_url, data=json.dumps(payload), headers={"Content-Type": "application/json"})

# Check the response status code to ensure the message was sent successfully
if response.status_code == 204:
    print("Message sent successfully!")
else:
    print(f"Failed to send message with status code {response.status_code}")

# Send the message at the user's defined seconds
time.sleep({time_seconds})