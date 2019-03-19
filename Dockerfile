FROM stefanfritsch/baseimage_statup:0.11
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

RUN groupadd -g 654339 selenium \
    && useradd -u 654339 -g selenium selenium

RUN apt-get update \
    && apt-get install -y --no-install-recommends npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g selenium-side-runner

RUN mkdir /sides \
    && chown selenium: /sides
VOLUME ["/sides"]

RUN mkdir /out \
    && chown selenium: /sides
VOLUME ["/out"]

COPY selenium-side-runner.sh /etc/service/selenium-side-runner/run
COPY chmod +x /etc/service/selenium-side-runner/run

CMD ["/sbin/my_init"]
