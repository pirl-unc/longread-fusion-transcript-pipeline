# Start your image with a node base image
FROM ubuntu:latest

RUN apt update && apt install -y sbcl

# The /app directory should act as the main application directory
WORKDIR /usr/src

# Start the app using serve command
CMD [ "echo", "'hello world'" ]
