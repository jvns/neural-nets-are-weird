FROM continuumio/anaconda

RUN chmod a+rwx /home

RUN apt-get update && apt-get install -y \
  build-essential \
  coreutils \
  imagemagick \
  libatlas-base-dev \
  libboost-all-dev \
  libboost-python-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  libhdf5-serial-dev \
  libleveldb-dev \
  liblmdb-dev \
  libopencv-dev \
  libprotobuf-dev \
  libsnappy-dev \
  protobuf-compiler

# Copy the patch that will
#  - specify the hdf5_serial libraries in the Makefile
#  - configure Makefile.config.example for CPU-only usage
#  - enable force_backward in /models/bvlc_googlenet/deploy.prototxt
COPY caffe.patch /tmp/caffe.patch

ENV CAFFE_REVISION cc521a0801143c242f5da0e95737070c02ce15ab
RUN git clone --depth 1 https://github.com/BVLC/caffe.git /opt/caffe \
  && cd /opt/caffe \
  && git reset --hard $CAFFE_REVISION \
  && patch -p1 < /tmp/caffe.patch \
  && cp Makefile.config.example Makefile.config \
  && make all -j8 \
  && make pycaffe -j8

RUN conda install protobuf
RUN conda install opencv

COPY bvlc_googlenet.caffemodel /models/bvlc_googlenet.caffemodel

# get labels for image class outputs(will be important!)
RUN /opt/caffe/data/ilsvrc12/get_ilsvrc_aux.sh

#RUN pip install --upgrade git+git://github.com/lisa-lab/pylearn2.git
#RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
#RUN pip install --no-deps git+git://github.com/Lasagne/Lasagne
#RUN cd /opt && \
#  git clone --depth 1 git://github.com/kitofans/caffe-theano-conversion

#RUN git clone https://github.com/piergiaj/caffe-to-theano.git --depth 1 /opt/caffe-to-theano

#RUN cd /opt && git clone https://github.com/yosinski/deep-visualization-toolbox.git
