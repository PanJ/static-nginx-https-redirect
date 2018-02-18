FROM nginx:alpine

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80

CMD /start.sh