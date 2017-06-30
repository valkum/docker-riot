FROM node:8-alpine

RUN apk update \
    && apk add --no-cache \
        curl \
        git \
        libevent \
        libffi \
        libjpeg-turbo \
        libssl1.0 \
        nodejs \
        sqlite-libs \
        unzip \
        ; \
    npm install -g webpack http-server \
    && curl -L https://github.com/vector-im/riot-web/archive/master.zip -o v.zip \
    && unzip v.zip \
    && rm v.zip \
    && mv riot-web-master riot-web \
    && cd riot-web \
    && npm install \
    && rm -rf /riot-web/node_modules/phantomjs-prebuilt/phantomjs \
    && GIT_VEC=$(git ls-remote https://github.com/vector-im/riot-web master | cut -f 1) \
    && echo "riot: master ($GIT_VEC)" > /riot.version \
    && npm run build \
    ; \
    ln -s /data/config.json /riot-web/webapp/config.json \
    ; \
    apk del \
        git \
        unzip \
        ; \
    rm -rf /var/lib/apk/* /var/cache/apk/*

WORKDIR /riot-web/webapp
EXPOSE 8080
CMD [ \
    "http-server", \
    "-p", \
    "8080", \
    "-A", \
    "0.0.0.0", \
    "-c", \
    "3500" \
]
