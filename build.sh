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