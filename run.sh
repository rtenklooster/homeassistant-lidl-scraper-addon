#!/bin/sh

# Load bot token and database name from options
BOT_TOKEN=$(jq --raw-output '.bot_token' /data/options.json)

# Debugging: Print the first 4 characters of the bot token
echo "Bot token starts with: ${BOT_TOKEN:0:4}"

# Clone or update the repository
if [ -d "/usr/src/app/Lidl-scraper-telegram" ]; then
    cd /usr/src/app/Lidl-scraper-telegram
    git pull
else
    git clone https://github.com/rtenklooster/Lidl-scraper-telegram.git
    cd Lidl-scraper-telegram
fi
# Create .env file with bot token and database name
echo "TOKEN=$BOT_TOKEN" > .env

# Remove incorrect dotenv dependency
sed -i '/dotenv==0.21.0/d' requirements.txt

# Install Python dependencies
pip3 install -r requirements.txt
pip3 install python-dotenv

# Load environment variables from .env file
export $(grep -v '^#' /usr/src/app/.env | xargs)

# Run the script
DATABASE_PATH="/data/lidl_scraper.db"
python3 bot.py --db-path "$DATABASE_PATH"