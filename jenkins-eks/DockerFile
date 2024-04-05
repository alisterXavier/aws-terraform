FROM ubuntu:latest AS BUILD

WORKDIR /app

RUN npm install
RUN npm run build

FROM alpine:latest AS PRODUCTION

WORKDIR /app

COPY --from=BUILD /app/package.json /app
COPY --from=BUILD /app/dist /app

RUN npm install --PRODUCTION

EXPOSE 3000
CMD [ "npm", "start " ]