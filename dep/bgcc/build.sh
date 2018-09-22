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

SRCTAR=v2.2.7.tar.gz


if [ -f ${SRCTAR} -a -f "output/include/bgcc.h" -a -f "output/include/openssl/ssl.h" -a -f "output/lib/libbgcc.a" -a -f "output/lib/libssl.a" ]; then
    exit 0;
fi

if [ ! -f ${SRCTAR} ]; then
    curl --connect-timeout 10 --location-trusted -k -O https://github.com/sudot/BGCC/archive/${SRCTAR}
fi

if [ $? != 0 -o ! -f ${SRCTAR} ]; then
    echo "can't find ${SRCTAR}, build failed";
    exit 1;
fi

tar xzf ${SRCTAR} && make -C BGCC-2.2.7 && cp -r BGCC-2.2.7/output ./ && exit 0


exit 1
