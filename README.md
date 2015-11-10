```
docker build -t neural-nets-fun:caffe .
docker run -i -p 9999:8888 -v ~/work/neural-nets:/neural-nets -t neural-nets-fun:caffe /bin/bash -c 'export PYTHONPATH=/opt/caffe/python && cd /neural-nets && ipython notebook --no-browser --ip 0.0.0.0'
```

https://github.com/BVLC/caffe/blob/master/examples/00-classification.ipynb

```
net = caffe.Net('/opt/caffe/models/bvlc_googlenet/deploy.prototxt', '/models/bvlc_googlenet.caffemodel', caffe.TEST)
```

how to calculate gradients: https://github.com/BVLC/caffe/issues/833