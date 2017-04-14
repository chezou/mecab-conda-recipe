# mecab-conda-recipe

This repository is a recipe for MeCab to create conda package.

See more detail of conda package in [official document](https://conda.io/docs/building/recipe.html). Especialy for C extension, [this tutorial](https://conda.io/docs/build_tutorials/postgis.html) is nice to read.

## How to install

```
$ conda install -c chezou mecab
```

It will install mecab, mecab-ipadic and Python binding for MeCab.

## (For developper) How to create conda recipe

### Using docker image

I develpped this recipe with [Anaconda image with Docker](https://www.continuum.io/blog/developer-blog/anaconda-and-docker-better-together-reproducible-data-science).

```
$ docker pull continuumio/anaconda
$ docker run -i -v $(pwd):/root/mecab -t continuumio/anaconda /bin/bash
```

After running docker, you should install development tools such as gcc.

According to [the document](https://conda.io/docs/build_tutorials/postgis.html#build-script), it is required to install gcc For this recipe, 

```
# apt-get install g++ autoconf automake
```

### Prepare conda environment

Before you start development, you should install conda build tool.

```
$ conda install conda-build
$ conda upgrade conda
$ conda upgrade conda-build
```

### Write your recipe

After creating working directory, write `meta.yaml` to set package name, version, source repos and dependensies.


```
$ mkdir mecab
$ cd mecab
```

Example:

```
package:
  name: mecab
  version: "0.996"

source:
  git_url: https://github.com/taku910/mecab
  git_rev: 32041d9504d11683ef80a6556173ff43f79d1268

build:
  number: 0

requirements:
  run:
    - libgcc

about:
  home: http://taku910.github.io/mecab
  license: BSD,LGPL,GPL
```

### Write your build script

Finally, you should write `build.sh` which is to compile your package.

Example:

```
cd mecab
./configure --prefix=$PREFIX --with-charset=utf8

make
make install

cd ../mecab-ipadic
./configure --with-mecab-config=$PREFIX/bin/mecab-config --prefix=$PREFIX --with-charset=utf8 --with-dicdir=$PREFIX/lib/mecab/dic/ipadic
make
make install

cd ../mecab/python
swig -python -shadow -c++ ../swig/MeCab.i
python setup.py build
python setup.py install --prefix=$PREFIX
```

NOTE: Don't forget setting appropriate `$PREFIX` for every dependent components paths. By default, conda builds a package with prefix. Without prefix, conda will not move components into conda environment and they will be lost.

### Build the package

Let's build your package. This command create conda package archived with tar.gz.

```
$ conda build .
```

After the build is succeeded, you can install via local build files.

```
$ conda install mecab --use-local
```

### Upload and install your package from anaconda repo

If you want to disribute your package, you can use anaconda repository. It requires anaconda client, so you should install via conda.

```
$ conda install anaconda-client
```

After creating your [anaconda.org](http://anaconda.org/) account, you can login and upload your package.

```
$ anaconda login
# Input your anaconda.org user name and password...
$ anaconda upload /opt/conda/conda-bld/linux-64/mecab-0.996-1.tar.bz2
```

Now, we can install the package via anaconda repository.

```
$ conda install -c chezou mecab
```

NOTE: Replace `chezou` into your anaconda.org user name.
