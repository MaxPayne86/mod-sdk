# docker build -t mod-sdk:latest .
# docker run -it -d --network host -v /local/path/to/lv2/plugins:/lv2 --name "mod-sdk" mod-sdk:latest

FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y build-essential liblilv-dev phantomjs python3-pil python3-pystache python3-setuptools python3-pyinotify python3-dev git python3-pip

ENV LV2_PATH="/lv2"

RUN mkdir /modsdk

WORKDIR /modsdk

RUN git clone https://github.com/tornadoweb/tornado.git \
    && cd tornado \
    && git checkout v4.3.0 \
    && python3 setup.py build \
    && python3 setup.py install

COPY . /modsdk/mod-sdk

RUN cd mod-sdk \
    && python3 setup.py build

RUN pip3 install pydispatcher

ENTRYPOINT ./mod-sdk/development_server.py
