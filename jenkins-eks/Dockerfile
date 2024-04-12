FROM node:16-alpine AS BUILD

WORKDIR /app

COPY ./ /app/

RUN npm install
RUN npm run build-docker

FROM node:16-alpine AS PRODUCTION

WORKDIR /app

COPY --from=BUILD /app/package.json /app
COPY --from=BUILD /app/dist /app

RUN npm install --PRODUCTION

EXPOSE 3000
CMD [ "npm", "start " ]