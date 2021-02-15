FROM rakudo-star:2020.01
LABEL Maintainer Richard Hainsworth, aka finanalyst
WORKDIR /raku-dox
ARG cro_version=0.8.4

COPY resources/docker-config.raku config.raku
COPY lib lib/
COPY t t/
COPY META6.json .
COPY bin bin/
COPY LICENSE .

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get -y --no-install-recommends install apt-utils \
    && apt-get -y --no-install-recommends install build-essential make nodejs libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && zef upgrade OpenSSL \
    && zef install 'Cro::Core:ver<'$cro_version'>' \
    && zef install 'Cro::TLS:ver<'$cro_version'>' \
    && zef install 'Cro::HTTP:ver<'$cro_version'>' \
    && zef install 'Raku::Pod::Render' \
    && raku-pod-render-install-highlighter \
    && zef install . --deps-only \
    && raku -I. -c bin/Raku-Doc

EXPOSE 30000
CMD raku -I. bin/Raku-Doc && bash