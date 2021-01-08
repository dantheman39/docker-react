# In AWS this won't work, using an unnamed builder
# FROM node:alpine as builder
FROM node:alpine

WORKDIR /usr/app

COPY package.json ./
RUN yarn
# Note that if we use docker volumes and docker-compose, this may
# not be strictly necessary, but good to leave it in since this
# would be required with normal docker.
COPY ./ ./

RUN yarn build

FROM nginx
# Elastic beanstalk uses this
EXPOSE 80
# If AWS has a problem with this, too. Do --from=0
# COPY --from=builder /usr/app/dist /usr/share/nginx/html
COPY --from=0 /usr/app/dist /usr/share/nginx/html
# Default command of nginx container will do the work for us.
