Основная СУБД для хранения данных - PostgreSQL. В файлах system_db описана общая модель БД с указанием принадлежности к сервису.
Так как система - read-intencive, то решено часть данных, задейственных при чтении постов, геолокаций прихранивать в кэш - Redis.
В файле cache описаны данные, которые будут хранятся в кэш.

## Расчет дисков на 1 год
### Posts
```
traffic_per_second = 70 750 Mb/s
capacity = 50 Mb/s * 86400 * 365 = 1577 Tb = 1.6 Pb
iops = 1417

HDD

Disks_for_capacity = 1577 Tb / 20 Tb = 78,85 = 79
Disks_for_throughput = 70 750 Mb/s / 100 Mb/s = 707,5 = 708
Disks_for_iops = 1417 / 100 = 14,17 = 15
Disks = max (79, 708, 15) = 708

SDD (nVME)

Disks_for_capacity = 1577 Tb / 25.6 Tb = 62
Disks_for_throughput = 70 750 Mb/s / 3 Gb/s = 23,583 = 24
Disks_for_iops = 1417 / 10 000 = 1
Disks = max (62, 24, 1) = 62

Хранение будет разделено на горячее и холодное.
Горячие данные будут храниться на SSD (nVME), холодное на более дешевых дисках - HDD/
Пусть SSD диск будет хранить данные глубиной 4 месяца 
SDD disks = (1577 * 4/12 ) /  25.6 Tb = 21 disks
HDD disks = (1577 * 8/12 ) /  25.6 Tb = 52 disks
Hosts = 73/2 = 37
```
### Reaction
```
traffic_per_second = 72 Mb/s 
capacity = 2 Mb/s * 86400 * 365 = 64 Tb
iops = 1400

HDD

Disks_for_capacity = 64 Tb / 20 Tb = 4
Disks_for_throughput = 72 Mb/s / 100 Mb/s = 0,72 = 1
Disks_for_iops = 1400 / 100 = 14
Disks = max (4, 1, 14) = 14

SDD (nVME)

Disks_for_capacity = 64 Tb / 25.6 Tb = 3
Disks_for_throughput = 72 Mb/s / 3 Gb/s = 0.024 = 1
Disks_for_iops = 1400 / 10 000 = 0.14 = 1
Disks = max (3, 1, 1) = 3

Хранение будет на SSD (nVME)
SDD disks = 4 (с запасом)
Hosts = 4/2 = 2

```
### Comment
```
traffic_per_second = 56 Mb/s
capacity = 6 Mb/s * 86400 * 365 = 192 Tb
iops = 460

HDD

Disks_for_capacity = 192 Tb / 20 Tb = 10
Disks_for_throughput = 56 Mb/s / 100 Mb/s = 0.56 = 1
Disks_for_iops = 460 / 100 = 5
Disks = max (10, 1, 5) = 10

SDD (SATA)

Disks_for_capacity = 192 Tb / 25.6 Tb = 8
Disks_for_throughput = 56 Mb/s / 500 Mb/s = 1
Disks_for_iops =  460 / 1000 = 1
Disks = max (8, 1, 1) = 8

SDD (nVME)

Disks_for_capacity = 192 Tb / 25.6 Tb = 8
Disks_for_throughput = 56 Mb/s / 3 Gb/s = 0.18
Disks_for_iops =  460 / 10 000 = 0.046
Disks = max (8, 0.18, 0.046) = 8

Хранение будет на SSD (SATA)
SDD disks = 8
Hosts = 8/2 = 4

```

### Geo
```
traffic_per_second = 70 Mb/sec
capacity = 0,5 Mb/s * 86400 * 365 = 16 Tb
iops = 1754

HDD

Disks_for_capacity = 16 Tb / 20 Tb = 1
Disks_for_throughput = 70 Mb/sec / 100 Mb/s = 1
Disks_for_iops = 1754 / 100 = 18
Disks = max (1, 1, 18) = 18

SDD (SATA)

Disks_for_capacity = 16 Tb  / 25.6 Tb = 1
Disks_for_throughput = 70 Mb/sec / 500 Mb/s = 1
Disks_for_iops =  1754 / 1000 = 2
Disks = max (1, 1, 2) = 2

SDD (nVME)

Disks_for_capacity = 16 Tb  / 25.6 Tb = 1
Disks_for_throughput = 70 Mb/sec / 3 Gb/s = 1
Disks_for_iops =  1754 / 10 000 = 1
Disks = max (1, 1, 1) = 1

Хранение будет на SSD (nVME)
SDD disks = 2 (с запасом)
Hosts = 2/2 = 1

```
### Subscription
```
traffic_per_second = 25 Mb/sec
capacity = 0,5 Mb/s * 86400 * 365 = 16 Tb
iops = 590

HDD

Disks_for_capacity = 16 Tb / 20 Tb = 1
Disks_for_throughput = 25 Mb/sec / 100 Mb/s = 1
Disks_for_iops = 590 / 100 = 6
Disks = max (1, 1, 6) = 6

SDD (SATA)

Disks_for_capacity = 16 Tb  / 25.6 Tb = 1
Disks_for_throughput = 25 Mb/sec / 500 Mb/s = 1
Disks_for_iops =  590 / 1000 = 1
Disks = max (1, 1, 1) = 1

SDD (nVME)

Disks_for_capacity = 16 Tb  / 25.6 Tb = 1
Disks_for_throughput = 25 Mb/sec / 3 Gb/s = 1
Disks_for_iops =  590 / 10 000 = 1
Disks = max (1, 1, 1) = 1

Хранение будет на SSD (nVME)
SDD disks = 2 (с запасом)
Hosts = 2/2 = 1
```
