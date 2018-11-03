#!/usr/bin/env bash

echo "========== install tool-chain ================"
sudo apt-get install scons libssl-dev python-pip libffi-dev libcurl4-openssl-dev cmake


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
