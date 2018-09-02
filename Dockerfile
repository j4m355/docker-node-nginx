FROM ubuntu:latest

MAINTAINER Seif Attar <iam@seifattar.net>, j4m355 github.com/j4m355

ADD init.sh /usr/local/bin/init.sh
ADD start-nginx.sh /usr/local/bin/start-nginx.sh

ENV TZ 'Etc/UTC'

RUN echo $TZ > /etc/timezone && \
 apt-get update && apt-get install -y tzdata && \
 rm /etc/localtime && \
 ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
 dpkg-reconfigure -f noninteractive tzdata && \
 chmod a+x /usr/local/bin/init.sh && \
 chmod a+x /usr/local/bin/start-nginx.sh && \ 
 apt-get update && apt-get install -y wget gnupg ca-certificates --no-install-recommends
 RUN cd /tmp/ && wget http://nginx.org/keys/nginx_signing.key && \
 apt-key add /tmp/nginx_signing.key && \
 sh -c "echo 'deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx' > /etc/apt/sources.list.d/Nginx.list"
 RUN apt-get install -y curl
 RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
 apt-get update && apt-get install -y curl nginx nodejs  && \
 apt-get clean && \
 wget --ca-directory=/etc/ssl/certs -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 && \
 chmod +x /usr/local/bin/dumb-init
 RUN node -v
 RUN npm -v

COPY config/nginx.conf /etc/nginx/nginx.conf




COPY config/default /etc/nginx/conf.d/default.conf
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["echo", "No CMD specified, set a CMD to run in your Dockerfile"]
