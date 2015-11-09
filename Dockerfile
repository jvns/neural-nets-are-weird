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
# We do a bunch of super gross stuff here to edit the Makefile
RUN cd /opt/caffe \
   && cp Makefile.config.example Makefile.config \
   && sed -i  's@# ANACONDA_HOME.*@ANACONDA_HOME := /opt/conda@' Makefile.config \
   && sed -i  's@# PYTHON_INCLUDE :=.*@PYTHON_INCLUDE := $(ANACONDA_HOME)/include \\\\ @'  Makefile.config \
   && sed -i  's@# PYTHON_LIB := .*@PYTHON_LIB := $(ANACONDA_HOME)/lib@' Makefile.config \
   && sed -i  's@# CPU_ONLY := 1@CPU_ONLY := 1@' Makefile.config \ 
   && make all -j8

RUN apt-get -y --force-yes install libboost-python-dev

RUN cd /opt/caffe \
   && make pycaffe -j8

RUN export PYTHONPATH=$PYTHONPATH:/opt/caffe/python
