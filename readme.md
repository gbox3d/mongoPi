mongoPi
====

# 1. 소스빌드하기 

## method 1

```bash
git clone https://github.com/gbox3d/mongoPi.git
cd mongoPi
npm run build
```


## 설치과정 분석

필수 라이브러리 와 프로그램 설치 
```bash
sudo apt-get install scons libssl-dev python-pip libffi-dev libcurl4-openssl-dev cmake
```


파이썬 셋업  

```bash
cat > ./python-requirements.txt <<EOF
cheetah3==3.1.0
pyyaml==3.13
typing==3.6.4
EOF

sudo pip install -r ./python-requirements.txt
```

mongo-c-driver 컴파일 & 설치 

```bash
wget https://github.com/mongodb/mongo-c-driver/archive/1.13.0.tar.gz
tar xzvf 1.13.0.tar.gz
cd mongo-c-driver-1.13.0/
cmake . && make install
```


드디어 소스 컴파일
```bash
 
tar xzvf mongodb-src-r4.0.3.tar.gz
cd mongodb-src-r4.0.3

./buildscripts/scons.py --link-model=dynamic --install-mode=hygienic --disable-warnings-as-errors --enable-free-mon=off --js-engine=none --dbg=off --wiredtiger=off --use-system-mongo-c=on --allocator=system CPPPATH="/usr/local/include/libbson-1.0 /usr/local/include/libmongoc-1.0" LIBPATH="/usr/local/lib" CCFLAGS="-mabi=aapcs-linux -march=armv7-a" install-embedded-{dev,test} -j1

```


## method 2 (for 32bit only)

시스템 버전 과 프로세서 확인   
```bash 
uname -a
```
소스 받기 

```bash
wget https://fastdl.mongodb.org/src/mongodb-src-r3.2.12.tar.gz

```

라이브러리 설치

```bash
sudo aptitude install scons build-essential
sudo aptitude install libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev
sudo aptitude install python-pymongo
```
 
스왑파일 확보 ( 컴파일 작업후 삭제)
```bash
sudo dd if=/dev/zero of=/mytempswapfile bs=1024 count=524288
sudo chmod 0600 /mytempswapfile
sudo mkswap /mytempswapfile
sudo swapon /mytempswapfile
```

arm 프로세서용 환경 설정

```bash
cd src/third_party/mozjs-38/
./get_sources.sh
./gen-config.sh arm linux
cd -
```


코어 모듈만 컴파일 하기
```bash
scons core --wiredtiger=off --mmapv1=on --disable-warnings-as-errors
```


### 참고자료
https://medium.com/@mattalord/embedded-mongodb-4-0-on-raspberry-pi-e50fd1d65e43
http://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/
