import subprocess
import re
import requests
import json
import time

# Execute the "vcgencmd measure_temp" command and capture the output
output = subprocess.check_output(['vcgencmd', 'measure_temp']).decode('utf-8')

# Extract the temperature value from the output using a regular expression
temperature = re.findall(r'\d+\.\d+', output)[0]

# Build the message to send to the Discord webhook
message = f"Temp: {temperature}°C"

# Define the Discord webhook URL
webhook_url = "https://discord.com/api/webhooks/WEBHOOK_ID/WEBHOOK_TOKEN"

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

# Send the message every 60 seconds
time.sleep(60)