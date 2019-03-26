FROM stefanfritsch/baseimage_statup:0.11
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

RUN groupadd -g 654339 selenium \
    && useradd -m -u 654339 -g selenium selenium

RUN apt-get update \
    && apt-get install -y --no-install-recommends npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install --save -g \
        selenium-side-runner@3.5.10 \
        jest@>=23.0.0 \
        jest-environment-node@^23.1.0 \
        jest-environment-selenium@2.1.0 \
        selenium-webdriver@4.0.0-alpha.1

COPY selenium-side-runner.sh /etc/service/selenium-side-runner/run
RUN  chmod +x /etc/service/selenium-side-runner/run


RUN apt-get update \
    && apt-get install -y --no-install-recommends python-pip python-setuptools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install prometheus_client

COPY prometheus-http.sh /etc/service/prometheus-http/run
RUN  chmod +x /etc/service/prometheus-http/run


RUN mkdir /sides \
    && chown selenium: /sides
VOLUME ["/sides"]

RUN mkdir /out \
    && chown selenium: /sides
VOLUME ["/out"]

CMD ["/sbin/my_init"]
