#!/bin/bash

echo "aa"
echo $SALOME_URL
echo $SALOME_FILE_RUN

cd /opt
curl ${SALOME_URL} -o ${SALOME_FILE_RUN}
chmod +x ${SALOME_FILE_RUN}

# check file
if md5sum -c $SALOME_FILE_MD5; then
  rm -f $SALOME_FILE_MD5
else
  echo "checksum md5 fails"
  exit -1;
fi
if sha512sum -c $SALOME_FILE_SHA512SUM; then
  rm -f $SALOME_FILE_SHA512SUM
else 
  echo "checksum sha512sum fails"
  exit -1;
fi

# install salome-edf
./${SALOME_FILE_RUN}                           \
  -t /home/salome_user/salome                  \
  -a   /home/salome_user/salome/appli_V8_5_0   \
  -l English

