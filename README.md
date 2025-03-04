# CastleGameHosting

### Start Up
* Open a terminal and run `chmod +x file_transfer.sh`, then run `./file_transfer.sh`. This should load all of the necessary data into the ec2 instance.
* When connected to the EC2 instance, run `chmod +x server_setup.sh`, then run `./server_setup.sh`. This should upload and install all the packages we will need to run our back and front ends.
* Then, run `cd flask-app-home` and execute the flask app by running `python3 app.py`. 
* In a different terminal, connection to the EC2 instance and run `cd react-app-home` then run `npm run dev -- --host`. 
* Check the public IP address on the specific ports to make sure that the app is running (port 5000 for the backend and port 5173 for the frontend).