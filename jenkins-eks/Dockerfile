FROM node:16-alpine AS BUILD

WORKDIR /app

COPY ./ /app/


RUN npm install

RUN ls /app/node_modules/.bin

RUN npm run build

FROM node:16-alpine AS PRODUCTION

WORKDIR /app

COPY --from=BUILD /app/package.json /app
COPY --from=BUILD /app/dist /app

RUN npm install --PRODUCTION

EXPOSE 3000
CMD [ "npm", "start " ]