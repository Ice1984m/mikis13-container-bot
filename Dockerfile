FROM nginx:alpine

COPY site/ /usr/share/nginx/html/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

HEALTHCHECK \
  --interval=30s \
  --timeout=5s \
  --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/ >/dev/null || exit 1

CMD ["nginx","-g","daemon off;"]
