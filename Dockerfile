FROM node:14

WORKDIR /home/ubuntu/jenkins/workspace/project-2/step-project-2

COPY package*.json ./

RUN npm install

COPY . .

# Expose the port the app runs on
EXPOSE 3000

ENTRYPOINT ["npm"]
# Define the command to run the app
CMD ["start"]
