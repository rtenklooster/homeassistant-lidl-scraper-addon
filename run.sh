#!/bin/sh

# Load bot token from options
BOT_TOKEN=$(jq --raw-output '.bot_token' /data/options.json)

# Create .env file with bot token
echo "BOT_TOKEN=$BOT_TOKEN" > /usr/src/app/.env

# Clone or update the repository
if [ -d "/usr/src/app/Lidl-scraper-telegram" ]; then
    cd /usr/src/app/Lidl-scraper-telegram
    git pull
else
    git clone https://github.com/rtenklooster/Lidl-scraper-telegram.git
    cd Lidl-scraper-telegram
fi

# Remove incorrect dotenv dependency
sed -i '/dotenv==0.21.0/d' requirements.txt

# Install Python dependencies
pip3 install -r requirements.txt
pip3 install python-dotenv

# Run the script
python3 bot.py