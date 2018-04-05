FROM node:argon

# Create app directory
RUN mkdir -p /usr/src
ADD app/ /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
RUN npm install

EXPOSE 3000
CMD [ "npm", "start" ]
