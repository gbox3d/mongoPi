mongoPi
====

# 1. 바이너리 배포판 설치하기
pimongo_inst.sh 스크립트 실행

mongo로 쉘에 접속되지않으면 한번더 몽고 디비 설치한다.

```sh
sudo apt-get install mongodb-server
```
위와 같이 하면 예전 버전이 아닌 새로운 버전으로 나오며 아까의 에러는 잡혀있다.(2020.2.20 현재)




# 2. 소스빌드하기 

## method 1 (for 32bit only)

시스템 버전 과 프로세서 확인   
```bash 
uname -a
```
소스 받기 

```bash
wget https://fastdl.mongodb.org/src/mongodb-src-r3.2.12.tar.gz

tar xvf mongodb-src-r3.2.12.tar.gz
cd mongodb-src-r3.2.12

```

라이브러리 설치

```bash
sudo apt-get install -y scons build-essential 
sudo apt-get install -y libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev
sudo apt-get install -y python-pymongo
```
 
스왑파일 확보 ( 컴파일 작업후 삭제)

```bash
sudo dd if=/dev/zero of=/mytempswapfile bs=1024 count=524288
sudo chmod 0600 /mytempswapfile
sudo mkswap /mytempswapfile
sudo swapon /mytempswapfile
```

또는 
/etc/dphys-swapfile 파일을 열어서 CONF_SWAPSIZE 를 2048로 수정합니다.

```bash
# set size to absolute value, leaving empty (default) then uses computed value
#   you most likely don't want this, unless you have an special disk situation
# CONF_SWAPSIZE=100
CONF_SWAPSIZE=2048
```

스왑 서비스 재시작하여 변경된 설정을 반영시켜주면 스왑 크기가 대략 20배가 됩니다. 
```bash

sudo /etc/init.d/dphys-swapfile restart
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
http://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/

### 버전별 최신 소스
https://fastdl.mongodb.org/src/mongodb-src-r3.2.21.tar.gz  
https://fastdl.mongodb.org/src/mongodb-src-r3.4.18.tar.gz  
https://fastdl.mongodb.org/src/mongodb-src-r3.6.8.tar.gz  

## method 2( mongo embeded )

몽고디비 임베디드 이다.  
사실상 이건 sqlite 같은 것이다. 별쓸모는 없다.

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
영겁의 시간이 흐르고.....  
인스톨 하기 

```bash
cd build/install/
cp -R * /usr/local/
```

권한 에러가 뜨면  sudo chown -R $(whoami) /usr/local/  



### 참고자료
https://medium.com/@mattalord/embedded-mongodb-4-0-on-raspberry-pi-e50fd1d65e43

