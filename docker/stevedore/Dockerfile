ARG docker_version=20.10
FROM docker:${docker_version}-dind

WORKDIR /

# COPY files/demo-magic.sh /demo

## NOTE: bash is requred to use demo-magic.sh
RUN apk update \
    && apk add --no-cache \
        bash \
        curl \
        pv \
    && rm -rf /var/cache/apk/*

## Install Stevedore
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/gostevedore/stevedore/main/scripts/install.sh)" -- -b /usr/local/bin/stevedore

# COPY demo /demo
COPY files/scripts/* /

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/demo.sh" ]
