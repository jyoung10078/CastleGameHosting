#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo yum update -y || sudo apt update -y

# Install Node.js & npm (Amazon Linux 2 or Ubuntu)
echo "Installing Node.js and npm..."
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash - 2>/dev/null || curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo yum install -y nodejs || sudo apt install -y nodejs

# Verify Node.js installation
node -v && npm -v

# Install git if not installed
echo "Installing Git..."
sudo yum install -y git || sudo apt install -y git

# Install Python & Pip
echo "Installing Python and Pip..."
sudo yum install -y python3 python3-pip || sudo apt install -y python3 python3-pip

# Clone React frontend and Flask backend
echo "Cloning repositories..."
git clone https://github.com/your-username/your-react-app.git /home/ec2-user/react-app
git clone https://github.com/your-username/your-flask-app.git /home/ec2-user/flask-app

# Set up React frontend
cd /home/ec2-user/react-app
echo "Installing React dependencies..."
npm install
echo "Building React app..."
npm run build

# Set up Flask backend
cd /home/ec2-user/flask-app
echo "Setting up Flask backend..."
pip3 install -r requirements.txt

# Create a systemd service for Flask
echo "Creating systemd service for Flask..."
sudo bash -c 'cat > /etc/systemd/system/flask-app.service <<EOF
[Unit]
Description=Flask Backend
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/flask-app
ExecStart=/usr/bin/python3 /home/ec2-user/flask-app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Start and enable Flask service
sudo systemctl daemon-reload
sudo systemctl start flask-app
sudo systemctl enable flask-app

# Install and configure Nginx
echo "Installing Nginx..."
sudo yum install -y nginx || sudo apt install -y nginx

# Configure Nginx for React and Flask
echo "Configuring Nginx..."
sudo bash -c 'cat > /etc/nginx/nginx.conf <<EOF
events { }

http {
    server {
        listen 80;
        server_name _;

        location / {
            root /home/ec2-user/react-app/build;
            index index.html;
            try_files \$uri /index.html;
        }

        location /api/ {
            proxy_pass http://127.0.0.1:5000/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF'

# Restart Nginx to apply changes
echo "Restarting Nginx..."
sudo systemctl restart nginx
sudo systemctl enable nginx

# Open HTTP and HTTPS ports in the firewall
echo "Opening firewall ports..."
sudo firewall-cmd --add-service=http --permanent || sudo ufw allow 'Nginx Full'
sudo firewall-cmd --reload || sudo ufw reload

# Success message
echo "React frontend and Flask backend setup completed! Access your app via your EC2 public IP."
