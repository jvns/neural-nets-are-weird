FROM continuumio/anaconda

RUN apt-get update

RUN apt-get -y --force-yes install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
RUN apt-get -y --force-yes install build-essential

RUN echo deb http://cz.archive.ubuntu.com/ubuntu trusty main universe > /etc/apt/sources.list
RUN apt-get update

RUN apt-get -y --force-yes install --no-install-recommends libboost-all-dev
RUN apt-get -y --force-yes install libgflags-dev libgoogle-glog-dev liblmdb-dev

#set CPU_ONLY := 1
RUN apt-get -y --force-yes install libatlas-base-dev

RUN git clone --depth 1 https://github.com/BVLC/caffe.git /opt/caffe
RUN apt-get -y --force-yes install coreutils

# base64'd patch for the Makefile
RUN cd /opt/caffe \
   && cp Makefile.config.example Makefile.config \
   && echo LS0tIE1ha2VmaWxlLmNvbmZpZy5leGFtcGxlCTIwMTUtMTEtMDcgMTU6NDU6MTIuNTEzNjQ3ODc2IC0wNTAwCisrKyBNYWtlZmlsZS5jb25maWcJMjAxNS0xMS0wOCAyMDozODoyMi4xMDcwNTA2MDggLTA1MDAKQEAgLTUsNyArNSw3IEBACiAjIFVTRV9DVUROTiA6PSAxCiAKICMgQ1BVLW9ubHkgc3dpdGNoICh1bmNvbW1lbnQgdG8gYnVpbGQgd2l0aG91dCBHUFUgc3VwcG9ydCkuCi0jIENQVV9PTkxZIDo9IDEKK0NQVV9PTkxZIDo9IDEKIAogIyB1bmNvbW1lbnQgdG8gZGlzYWJsZSBJTyBkZXBlbmRlbmNpZXMgYW5kIGNvcnJlc3BvbmRpbmcgZGF0YSBsYXllcnMKICMgVVNFX09QRU5DViA6PSAwCkBAIC02NSwxNCArNjUsMTQgQEAKIAkJL3Vzci9saWIvcHl0aG9uMi43L2Rpc3QtcGFja2FnZXMvbnVtcHkvY29yZS9pbmNsdWRlCiAjIEFuYWNvbmRhIFB5dGhvbiBkaXN0cmlidXRpb24gaXMgcXVpdGUgcG9wdWxhci4gSW5jbHVkZSBwYXRoOgogIyBWZXJpZnkgYW5hY29uZGEgbG9jYXRpb24sIHNvbWV0aW1lcyBpdCdzIGluIHJvb3QuCi0jIEFOQUNPTkRBX0hPTUUgOj0gJChIT01FKS9hbmFjb25kYQotIyBQWVRIT05fSU5DTFVERSA6PSAkKEFOQUNPTkRBX0hPTUUpL2luY2x1ZGUgXAotCQkjICQoQU5BQ09OREFfSE9NRSkvaW5jbHVkZS9weXRob24yLjcgXAotCQkjICQoQU5BQ09OREFfSE9NRSkvbGliL3B5dGhvbjIuNy9zaXRlLXBhY2thZ2VzL251bXB5L2NvcmUvaW5jbHVkZSBcCitBTkFDT05EQV9IT01FIDo9IC9vcHQvY29uZGEKK1BZVEhPTl9JTkNMVURFIDo9ICQoQU5BQ09OREFfSE9NRSkvaW5jbHVkZSBcCisJCSAkKEFOQUNPTkRBX0hPTUUpL2luY2x1ZGUvcHl0aG9uMi43IFwKKwkJICQoQU5BQ09OREFfSE9NRSkvbGliL3B5dGhvbjIuNy9zaXRlLXBhY2thZ2VzL251bXB5L2NvcmUvaW5jbHVkZSBcCiAKICMgV2UgbmVlZCB0byBiZSBhYmxlIHRvIGZpbmQgbGlicHl0aG9uWC5YLnNvIG9yIC5keWxpYi4KIFBZVEhPTl9MSUIgOj0gL3Vzci9saWIKLSMgUFlUSE9OX0xJQiA6PSAkKEFOQUNPTkRBX0hPTUUpL2xpYgorUFlUSE9OX0xJQiA6PSAkKEFOQUNPTkRBX0hPTUUpL2xpYgogCiAjIEhvbWVicmV3IGluc3RhbGxzIG51bXB5IGluIGEgbm9uIHN0YW5kYXJkIHBhdGggKGtlZyBvbmx5KQogIyBQWVRIT05fSU5DTFVERSArPSAkKGRpciAkKHNoZWxsIHB5dGhvbiAtYyAnaW1wb3J0IG51bXB5LmNvcmU7IHByaW50KG51bXB5LmNvcmUuX19maWxlX18pJykpL2luY2x1ZGUK | base64 -d | patch -u Makefile.config

RUN cd /opt/caffe \
   && make all -j8

RUN apt-get -y --force-yes install libboost-python-dev

RUN cd /opt/caffe \
   && make pycaffe -j8

RUN mkdir /models
RUN cd /models && wget http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel

RUN conda install protobuf
RUN conda install opencv
RUN apt-get -y --force-yes install imagemagick

# get labels for image class outputs(will be important!)
RUN /opt/caffe/data/ilsvrc12/get_ilsvrc_aux.sh

#RUN pip install --upgrade git+git://github.com/lisa-lab/pylearn2.git
#RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
#RUN pip install --no-deps git+git://github.com/Lasagne/Lasagne
#RUN cd /opt && \
#  git clone --depth 1 git://github.com/kitofans/caffe-theano-conversion

#RUN git clone https://github.com/piergiaj/caffe-to-theano.git --depth 1 /opt/caffe-to-theano

#RUN cd /opt && git clone https://github.com/yosinski/deep-visualization-toolbox.git
