DOCKER=docker
WGET=wget

TAG=neural-nets-fun:caffe

bvlc_googlenet.caffemodel:
	${WGET} http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel

.PHONY: image
image: Dockerfile bvlc_googlenet.caffemodel
	${DOCKER} build -t ${TAG} .

.PHONY: shell
shell:
	${DOCKER} run --rm -it ${TAG}

.PHONY: notebook
notebook:
	${DOCKER} run --rm -it \
		-e "PYTHONPATH=/opt/caffe/python" \
		-e "HOME=/home/you" \
		-p 9990:9990 \
		-u `id -u`:`id -g` \
		-v ${PWD}:/neural-nets \
		-w /neural-nets \
		-t ${TAG} \
		/bin/bash -c 'mkdir /home/you && jupyter notebook --NotebookApp.token="weirdness" --no-browser --ip 0.0.0.0 --port=9990'

