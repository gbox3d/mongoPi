#!/usr/bin/env bash

echo "========== install tool-chain ================"
sudo apt-get install scons libssl-dev python-pip libffi-dev libcurl4-openssl-dev cmake -y


echo "========== python requirements install ======="

cat > ./python-requirements.txt <<EOF
cheetah3==3.1.0
pyyaml==3.13
typing==3.6.4
EOF

sudo pip install -r ./python-requirements.txt

echo "== install mmongo-c-driver ==="

wget https://github.com/mongodb/mongo-c-driver/archive/1.13.0.tar.gz
tar xzvf 1.13.0.tar.gz
cd mongo-c-driver-1.13.0/
cmake . && make install

echo "== build mongodb =="

tar xzvf mongodb-src-r4.0.3.tar.gz
cd mongodb-src-r4.0.3

./buildscripts/scons.py --link-model=dynamic --install-mode=hygienic --disable-warnings-as-errors --enable-free-mon=off --js-engine=none --dbg=off --wiredtiger=off --use-system-mongo-c=on --allocator=system CPPPATH="/usr/local/include/libbson-1.0 /usr/local/include/libmongoc-1.0" LIBPATH="/usr/local/lib" CCFLAGS="-mabi=aapcs-linux -march=armv7-a" install-embedded-{dev,test} -j1