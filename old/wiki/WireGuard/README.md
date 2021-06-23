# How to using WireGuard to config a BGP Session

Notice: You need a routing software to set a BGP Session, [WireGuard](https://wireguard.com/) just a VPN Tunnel. But we use it to make site to site network.

This Demo System is working on Ubuntu

## Peer To Peer IP Address

If you are a novice of WireGuard, you should have use wg-quick.

But it's not working for peer to peer IP Address.

So, we need to use ```ip addr``` and ```ip link``` command to set

For example, if A is 10.121.211.254, B is 10.121.212.254

We will use this command in A

```ip addr add 10.121.211.254/32 peer 10.121.212.254/32 dev <interface>```

Corresponding, B should change IP Address of the servers on both ends

So, we can write a shell script, like this

```
#!/bin/bash
ip link add dev wireguard_peertopeer type wireguard
wg setconf wireguard_peertopeer /etc/wireguard/wireguard_peertopeer.conf
ip link set wireguard_peertopeer up
ip addr add 10.121.211.254/32 peer 10.121.213.254/32 dev wireguard_peertopeer
```

Need to notice, you need set ```AllowedIPs = 0.0.0.0/0, ::/0``` in the WireGuard config, and don't use command ```wg-quick up xxx```.

That will write 0.0.0.0/0 and ::/0 to your kernel, and you tunnel will stuck in a loop

```
[Interface]
PrivateKey = <PrivateKey>

# Server
[Peer]
PublicKey = <PublicKey>
AllowedIPs = 0.0.0.0/0, ::/0
EndPoint = <EndPoint>
PersistentKeepalive = 10
```

## using wg-quick to make tunnel

If you want to use ```wg-quick up xxx``` to make a tunnel. Yeah! It can work.

But it still not work in the peer to peer IP Address.

So we need make a config of WireGuard.

And it look like this

```
[Interface]
PrivateKey = <PrivateKey>
Address = <suggestion using /31 and /127>
TABLE = OFF

# Server
[Peer]
PublicKey = <PublicKey>
Endpoint = <Endpoint>
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 10
```

And use ```wg-quick up <your_config_name>```, it will be work!

Q: Why i set AllowedIPs be 0.0.0.0/0 and ::/0, it didn't write to kernal?

A: Because we using ```TABLE```, so WireGuard will not write route to kernal, it just write to routing table.

So it will not cover original routing.
