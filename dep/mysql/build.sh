#!/bin/bash

# Copyright 2002-2014 the original author or authors.

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


#mysql��Դ��tar���ļ���
MYSQL_SRCTAR=mysql-5.0.51b.tar.gz

if [ -f "output/include/mysql.h" -a -f "output/lib/libmysqlclient.a" ]; then
    exit 0;
fi

if [ ! -f ${MYSQL_SRCTAR} ]; then
    wget http://downloads.mysql.com/archives/get/file/mysql-5.0.51b.tar.gz
fi

if [ ! -f ${MYSQL_SRCTAR} ]; then
    echo "can't find ${MYSQL_SRCTAR}, build failed";
    exit 1;
fi

#ָ��mysqlԴ���tar��·��
MYSQL_THIRDSRC=$PWD
#mysql tar����ѹ���·����
MYSQL_SRC=mysql-5.0.51b
#mysql ��װ��·��, ���Ը�����Ҫ�����޸�
MYSQL_INSTALL=$PWD/mysql

#��ѹ
cd $MYSQL_THIRDSRC
tar xzf $MYSQL_SRCTAR

#����Ŀ¼���б��밲װ
cd $MYSQL_SRC
#����configure����
#��װ��$MYSQL_INSTALL, ����������������������������, 
CFLAGS=-fPIC ./configure --prefix=$MYSQL_INSTALL --with-charset=gbk --with--enable-local-infile --with-extra-charset=all --enable-thread-safe-client

if [ $? != 0 ]; then
    echo "configure FAILED! EXIT!";
    exit 1;
fi

#���벢��װ
make; make install

cd $MYSQL_INSTALL/..

#������������,�������Ҫ�����Ľ���ŵ���ǰĿ¼�µ�output�м���

mkdir output
mkdir output/include
mkdir output/lib
cp $MYSQL_INSTALL/include/mysql/*.h output/include
cp $MYSQL_INSTALL/lib/mysql/*.a output/lib


