#!/usr/bin/env bash


echo "install nodejs"
mkdir temp
cd temp
wget https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-armv6l.tar.xz
tar -xvf node-v10.15.3-linux-armv6l.tar.xz
sudo chown -R $(whoami) /usr/local/
( cd node-v10.15.3-linux-armv6l/ &&  cp -R * /usr/local/ )


cd ../
rm -rf temp

#
#echo "========== install mongodb ================"
#sudo apt-get install mongodb-server -y
#
#echo "========== update mongodb version ================"
#sudo service  mongodb stop
#echo "========== download binary ================"
#
#wget https://github.com/gbox3d/mongoPi/releases/download/001/mongopi.tar
#tar -xvf mongopi.tar
#
#echo "========== copy binary ================"
#
#sudo mv ./mongo /usr/bin/
#sudo mv ./mongod /usr/bin/
#sudo mv ./mongos /usr/bin/
#
#echo "========== restart service ================"
#
#sudo service  mongodb start
