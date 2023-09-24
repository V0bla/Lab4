#!/bin/bash
sudo -i
#task1
lsblk
zpool create test1 mirror  /dev/sd{b,c}
zpool create test2 mirror  /dev/sd{d,e}
zpool create test3 mirror  /dev/sd{f,g}
zpool create test4 mirror  /dev/sd{h,i}
zpool list
#task2
zfs set compression=lzjb test1
zfs set compression=lz4 test2
zfs set compression=gzip-9 test3
zfs set compression=zle test4
zfs get all | grep compression
for i in {1..4}; do wget -P /test$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
zfs get all | grep compressratio | grep -v ref
cd ~
wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download'
tar -zxvf archive.tar.gz
zpool import -d zpoolexport/ otus
zpool status
zpool get all otus > settings
#task3
wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
zfs receive otus/test@today < otus_task2.file
find /otus/test -name "secret_message" -exec cat {} \;