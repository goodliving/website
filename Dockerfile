FROM dhub.juxinli.com/blog/hugo as build
RUN mkdir /opt/hugo
WORKDIR /opt/hugo
ADD . /opt/hugo
RUN hugo --theme=beautifulhugo --baseUrl="http://192.168.200.20:8080/"

FROM nginx:alpine
COPY --from=build /opt/hugo/public /usr/share/nginx/html
