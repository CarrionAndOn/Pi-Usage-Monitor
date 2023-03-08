# Usage Monitor
 A python script that monitors the temperature, RAM usage, and CPU usage of a Linux system and sends it through a Discord webhook every minute.<br />
![it work](https://user-images.githubusercontent.com/30084485/223586659-3a030bed-69e8-43c8-8e23-083257df742e.png)<br />

# Installation
### `wget https://raw.githubusercontent.com/CarrionAndOn/Linux-Usage-Monitor/main/install.sh && bash install.sh`<br />
If what you're installing it on has a graphic desktop, you can download it directly from the releases.<br />
Or, you can install it manually with the instructions below.<br />

# Manual Installation
<b>NOTE: I HAVE ONLY TESTED THIS IN UBUNTU, NO IDEA IF IT WORKS IN ANY OTHER LINUX OPERATING SYSTEMS</b><br />
psutil MUST be installed for this to work.<br />
Install it with "pip install psutil"<br />
If you don't have pip, install python3-pip with "apt install python3-pip"<br />
<br />
Run `wget https://raw.githubusercontent.com/CarrionAndOn/Linux-Usage-Monitor/main/usagemonitor.py`<br />
Open the file with your preferred text editor<br />
Replace the webhook URL at line 17 with your webhook's URL<br />
Optionally, change the amount of time that it takes to send a new message at the bottom of the script. Default is a minute.<br />
Save the file<br />
Run the file with "python3 usagemonitor.py" to make sure it works<br />
Use systemctl, supervisor, nohup, or any other service daemon to run the file in the background<br />
An example service file for systemctl is in the source code.<br />
<b>If you use that example service, be sure to change the directory of where it runs the file to where you put the file.</b><br />

# Uninstallation
Run `systemctl stop usagemonitor && rm /home/usagemonitor.py && rm /etc/systemd/system/usagemonitor.service`<br />
The directories may be different if you installed manually.<br />
