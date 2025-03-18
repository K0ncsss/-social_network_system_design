Основная СУБД для хранения данных - PostgreSQL. В файлах system_db описана общая модель БД с указанием принадлежности к сервису.
Так как система - read-intencive, то решено часть данных, задейственных при чтении постов, геолокаций прихранивать в кэш - Redis.
В файле cache описаны данные, которые будут хранятся в кэш.

## Расчет дисков на 1 год
### Posts
```
traffic_per_second = 53 Gb/s
capacity = 50 Mb/s * 86400 * 365 = 1577 Tb = 1.6 Pb
iops = 1070

HDD

Disks_for_capacity = 1577 Tb / 20 Tb = 79
Disks_for_throughput = 53 Gb/s / 100 Mb/s = 53 000 Mb/s / 100 Mb/s = 530
Disks_for_iops = 1070 / 100 = 11
Disks = max (79, 530, 11) = 530

SDD (nVME)

Disks_for_capacity = 1577 Tb / 25.6 Tb = 62
Disks_for_throughput = 53 Gb/s / 3 Gb/s = 18
Disks_for_iops = 1070 / 10 000 = 1
Disks = max (62, 18, 1) = 62

Хранение будет разделено на горячее и холодное.
Горячие данные будут храниться на SSD (nVME), холодное на более дешевых дисках - HDD/
Пусть SSD диск будет хранить PF 4 месяца глубины
SDD disks = (1577 * 4/12 ) /  25.6 Tb = 21 disks
HDD disks = (1577 * 8/12 ) /  25.6 Tb = 52 disks
Hosts = 73/2 = 37
```
### Reaction
```
Т.к. реакции будут вычитываться вместе с постами, то
traffic_per_second = 2 Mb/s (write) + 5 Kb/s * 1050 RPS(reed of Posts) *20 = 107 Mb/s 
capacity = 2 Mb/s * 86400 * 365 = 64 Tb
iops = 1050 (of Posts) + 350 = 1400

HDD

Disks_for_capacity = 64 Tb / 20 Tb = 4
Disks_for_throughput = 107 Mb/s / 100 Mb/s = 1.5
Disks_for_iops = 1400 / 100 = 14
Disks = max (4, 1.5, 14) = 14

SDD (nVME)

Disks_for_capacity = 64 Tb / 25.6 Tb = 3
Disks_for_throughput = 107 Mb/s / 3 Gb/s = 0.36
Disks_for_iops = 1400 / 10 000 = 0.14
Disks = max (3, 0.36, 0.14) = 3

Хранение будет на SSD (nVME)
SDD disks = 4
Hosts = 4/2 = 2

```
### Comment
```
traffic_per_second = 56 Mb/s
capacity = 6 Mb/s * 86400 * 365 = 192 Tb
iops = 460

HDD

Disks_for_capacity = 192 Tb / 20 Tb = 10
Disks_for_throughput = 56 Mb/s / 100 Mb/s = 0.56
Disks_for_iops = 460 / 100 = 5
Disks = max (10, 0.56, 5) = 10

SDD (nVME)

Disks_for_capacity = 192 Tb / 25.6 Tb = 8
Disks_for_throughput = 56 Mb/s / 3 Gb/s = 0.18
Disks_for_iops =  460 / 10 000 = 0.046
Disks = max (8, 0.18, 0.046) = 8

Хранение будет на SSD (nVME)
SDD disks = 8
Hosts = 8/2 = 4

```

### Geo
```
Т.к. геолокации будут вычитываться вместе с постами, то
traffic_per_second = 1 Mb/s (write) + 1 Mb/s * 1050 RPS(reed of Posts) *20 = 21 Gb/s 
capacity = 1 Mb/s * 86400 * 365 = 32 Tb
iops = 1400

HDD

Disks_for_capacity = 32 Tb / 20 Tb = 2
Disks_for_throughput = 21 Gb/s / 100 Mb/s = 210
Disks_for_iops = 1400 / 100 = 14
Disks = max (2, 210, 14) = 210

SDD (nVME)

Disks_for_capacity = 32 Tb  / 25.6 Tb = 2
Disks_for_throughput = 21 Gb/s / 3 Gb/s = 7
Disks_for_iops =  1400 / 10 000 = 0.14
Disks = max (0.14, 7, 2) = 7

Хранение будет на SSD (nVME)
SDD disks = 8
Hosts = 8/2 = 4

```
### Subscription
```

```
