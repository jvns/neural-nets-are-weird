# neural nets are weird

Source code for the article [How to trick a neural network into thinking a panda is a vulture](https://codewords.recurse.com/issues/five/why-do-neural-networks-think-a-panda-is-a-vulture). Here's how to get it going! It will download about 1.5GB and take maybe half an hour to set up and compile everything, so don't expect it to be instant. Tested on Linux and OS X.

```
git clone https://github.com/jvns/neural-nets-are-weird
cd neural-nets-are-weird
docker build -t neural-nets-fun:caffe .
docker run -i -p 9990:9990 -v $PWD:/neural-nets -t neural-nets-fun:caffe /bin/bash -c 'export PYTHONPATH=/opt/caffe/python && cd /neural-nets && ipython notebook --no-browser --ip 0.0.0.0 --port=9990'
```

**On Linux:** Once you've run those commands, click on this link: [http://localhost:9990/notebooks/notebooks/neural-nets-are-weird.ipynb](http://localhost:9990/notebooks/notebooks/neural-nets-are-weird.ipynb) and you should be good to go! This starts an IPython Notebook server, which lets you run code interactively.

**On OSX:** You must use the address of the VM hosting Docker in the URL (not localhost). This address is shown when starting Docker, or you can get the *docker-address* by running the command ````docker-machine ip default```` Then point your browser to *http://docker-address:9990* and follow along with the instructions in the IPython notebook.
