#!/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      CC/LICENSE
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SRCTAR=boost_1_56_0.tar.gz

if [ -f "output/include/boost/config.hpp" -a -f "output/lib/libboost_system.a" ]; then
    exit 0;
fi

if [ ! -f ${SRCTAR} ]; then
    wget http://sourceforge.net/projects/boost/files/boost/1.56.0/boost_1_56_0.tar.gz;
fi

if [ ! -f ${SRCTAR} ]; then
    echo "can't find ${SRCTAR}, build failed";
    exit 1;
fi

NAME=`ls *.gz *.bz2 2>/dev/null`
echo build $NAME

#��װ��·��, ���Ը�����Ҫ�����޸�
INSTALL=$PWD/install

SRC=`basename ${SRCTAR} .tar.gz`
rm -rf $SRC
tar xzf ${SRCTAR}


#����Ŀ¼���б��밲װ
cd $SRC
sed -i -e 's/\(<toolset>gcc:<cxxflags>-Wno-variadic-macros\)/#\1/' libs/chrono/build/Jamfile.v2
sed -i -e 's/\(<toolset>gcc:<cxxflags>-Wno-variadic-macros\)/#\1/' libs/thread/build/Jamfile.v2

#����bjam
rm -rf bjam
sh bootstrap.sh

#���벢�Ұ�װ
./bjam --prefix=$INSTALL --threading=multi --link=static cxxflags='-fPIC -O2' cflags='-fPIC -O2' install
./bjam --prefix=$INSTALL --threading=multi --link=static --with-thread --with-chrono cxxflags='-fPIC -O2' cflags='-fPIC -O2' install
cd $INSTALL/..

#������������,�������Ҫ�����Ľ���ŵ���ǰĿ¼�µ�output�м���
rm -rf output
mkdir output
cp -r $INSTALL/include output
cp -r $INSTALL/lib output
#ɾ��lib�����.a�ļ�
find output/lib -type f ! -iname "*.a" -exec rm -rf {} \;
#ɾ��lib�����Ŀ¼
find output/lib -type d -empty | xargs rm -rf 
#ɾ��lib������������ļ�
find output/lib -type l -exec rm -rf {} \;

