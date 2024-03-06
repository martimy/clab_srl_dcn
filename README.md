# clab_yang_dcn

Data centre network using YANG.

This project is in-progress.



To start the lab

```
$ sudo clab deploy
```

To stop the lab

```
$ sudo clab destroy --cleanup
```



To access Nokia router:

```
$ docker exec -it clab-ynet-srl sr_cli
```

or 

```
$ ssh clab-ynet-srl
```

To exit, type 'quit'.


To test SNMP connection:

```
$ docker exec -it clab-ynet-mgm snmpwalk -v 2c -c linuxro 172.20.20.2
```
