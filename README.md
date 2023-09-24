# Домашнее задание №4 ZFS

## Цель:
- определить алгоритм с наилучшим сжатием;
- определить настройки pool’a;
- найти сообщение от преподавателей.
- составить список команд, которыми получен результат с их выводами.

## Результат:
### 1. Определить алгоритм с наилучшим сжатием;
- Создали пулы 
```
zpool create test1 mirror  /dev/sd{b,c}
```
```
[root@zfs ~]# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
test1   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
test2   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
test3   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
test4   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
```
- Задали различные алгоритмя сжатия
```
[root@zfs ~]# zfs get all | grep compression
test1  compression           off                    default
test2  compression           off                    default
test3  compression           off                    default
test4  compression           off                    default
[root@zfs ~]# zfs set compression=lzjb test1
[root@zfs ~]# zfs set compression=lz4 test2
[root@zfs ~]# zfs set compression=gzip-9 test3
[root@zfs ~]# zfs set compression=zle test4
[root@zfs ~]# zfs get all | grep compression
test1  compression           lzjb                   local
test2  compression           lz4                    local
test3  compression           gzip-9                 local
test4  compression           zle                    local
```
- Скопировали эталонный файл и получили результат
```
[root@zfs ~]# zfs get all | grep compressratio | grep -v ref
test1  compressratio         1.81x                  -
test2  compressratio         2.22x                  -
test3  compressratio         3.65x                  -
test4  compressratio         1.00x                  -
```
- Алгоритм gzip-9 лучше других справился с этим файлом.
### 2. Определить настройки pool’a.
- импортировали pool
```
[root@zfs ~]# zpool import -d zpoolexport/ otus
[root@zfs ~]# zpool status otus
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
```
- получили [описание настроек](./pool_settings)
### 3. Найти сообщение от преподавателей.
- восстановили файловую систему из снэпшота
```
zfs receive otus/test@today < otus_task2.file
```
- текст искомого сообщения: https://github.cоm/sindresorhus/awesоme
### 4. Составить список команд, которыми получен результат с их выводами.
- список команд и их выводов составлен.
- подготовлен скрипт zfs.sh и добавлен в vagrantfile