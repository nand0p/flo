FROM alpine

RUN apk add --no-cache nginx
RUN apk upgrade
RUN ln -sfv /dev/stdout /var/log/nginx/access.log
RUN ln -sfv /dev/stderr /var/log/nginx/error.log
RUN adduser -D -u 1000 -g 'www' www
RUN mkdir /run/nginx
RUN chown -R www:www /var/lib/nginx /run/nginx

COPY nginx.conf /etc/nginx/
COPY index.html /var/lib/nginx/html/
COPY flo.jpg /var/lib/nginx/html/

EXPOSE 80

CMD nginx -g 'daemon off;'

