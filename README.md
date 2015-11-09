```
docker build -t neural-nets-fun:caffe .
docker run -i -p 9999:8888 -t neural-nets-fun:caffe /bin/bash -c 'export PYTHONPATH=/opt/caffe/python && ipython'
```

```
caffe.Net('./models/bvlc_googlenet/deploy.prototxt', '../bvlc_googlenet.caffemodel', caffe.TEST)
```