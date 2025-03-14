FROM alpine:3.13

# Install dependencies
RUN apk add --no-cache python3 py3-pip git jq

# Set working directory
WORKDIR /usr/src/app

# Copy run script
COPY run.sh /usr/src/app/run.sh
RUN chmod +x /usr/src/app/run.sh

# Run the script
CMD ["/usr/src/app/run.sh"]