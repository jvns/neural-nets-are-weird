# neural nets are weird

If you want to get this working on your computer, this should work:

```
git clone https://github.com/jvns/neural-nets-are-weird
cd neural-nets-are-weird
docker build -t neural-nets-fun:caffe .
docker run -i -p 9990:8888 -v $PWD:/neural-nets -t neural-nets-fun:caffe /bin/bash -c 'export PYTHONPATH=/opt/caffe/python && cd /neural-nets && ipython notebook --no-browser --ip 0.0.0.0'
```

This should start a server with IPython Notebook running, and you can see the example at [http://localhost:9990/notebooks/notebooks/neural-nets-are-weird.ipynb](http://localhost:9990/notebooks/notebooks/neural-nets-are-weird.ipynb)
