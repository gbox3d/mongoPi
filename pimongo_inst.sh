#!/usr/bin/env bash

echo "========== update mongodb version ================"
sudo service  mongodb stop
echo "========== download binary ================"

wget https://github.com/gbox3d/mongoPi/releases/download/001/mongopi.tar
tar -xvf mongopi.tar

echo "========== copy binary ================"

sudo mv ./mongo /usr/bin/
sudo mv ./mongod /usr/bin/
sudo mv ./mongos /usr/bin/

echo "========== restart service ================"

sudo service  mongodb start