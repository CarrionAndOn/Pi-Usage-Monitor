# Temperature Monitor
 A python script that monitors the temperature of a Linux system and sends it through a Discord webhook every minute.

# Installation
Run "wget https://cdn.carrionandon.me/assets/temperature.py"<br />
Open the file with your preferred text editor<br />
Replace the webhook URL at line 17 with your webhook's URL<br />
Optionally, change the amount of time that it takes to send a new message at the bottom of the script. Default is a minute.<br />
Save the file<br />
Run the file with "python3 temperature.py" to make sure it works<br />
Use systemctl, supervisor, nohup, or any other service daemon to run the file in the background<br />
An example service file for systemctl is in the source code.<br />
![Screenshot 2023-03-07 145855](https://user-images.githubusercontent.com/30084485/223573347-3315bb17-b00f-4da3-8011-3b27078689a5.png)
