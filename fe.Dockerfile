FROM node:10

RUN git clone https://github.com/LamAnnieV/group_deployment_8.git

WORKDIR /group_deployment_8/frontend

RUN npm install --save-dev @babel/plugin-proposal-private-property-in-object

RUN npm install

EXPOSE 3000

CMD ["npm", "start"]

