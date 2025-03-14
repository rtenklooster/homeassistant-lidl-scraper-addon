#!/bin/sh

# Load bot token and database name from options
BOT_TOKEN=$(jq --raw-output '.bot_token' /data/options.json)
#DATABASE_NAME=$(jq --raw-output '.database_name' /data/options.json)

# Create .env file with bot token and database name
echo "BOT_TOKEN=$BOT_TOKEN" > /usr/src/app/.env
#echo "DATABASE_NAME=$DATABASE_NAME" >> /usr/src/app/.env

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

# Load environment variables from .env file
export $(grep -v '^#' /usr/src/app/.env | xargs)

# Run the script
DATABASE_PATH="/config/lidl_scraper.db"
python3 bot.py --db-path "$DATABASE_PATH" --bot-token "$BOT_TOKEN"