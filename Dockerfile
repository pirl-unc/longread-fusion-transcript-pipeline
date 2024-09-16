# Start your image with a node base image
FROM ubuntu

# The /app directory should act as the main application directory
WORKDIR /app

# Start the app using serve command
CMD [ "echo", "'hello world'" ]
