FROM node:10

RUN git clone https://github.com/LamAnnieV/group_deployment_8.git

WORKDIR /group_deployment_8/frontend

EXPOSE 300

RUN npm install --save-dev @babel/plugin-proposal-private-property-in-object

RUN npm install

CMD ["npm", "start"]

