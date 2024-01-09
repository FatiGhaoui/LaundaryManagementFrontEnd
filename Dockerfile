FROM node:latest as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
EXPOSE $VUE_APP_PORT
COPY ./ .
RUN npm run build
CMD [ "npm", "run", "build", "--", "--port", "$VUE_APP_PORT" ]

FROM nginx as production-stage
RUN mkdir /app
COPY --from=build-stage /app/dist /app
COPY nginx.conf /etc/nginx/nginx.conf