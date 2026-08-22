# Day 3 — Networking Fundamentals

## Topics Learned

- Network interfaces
- IPv4
- IPv6
- Subnets
- Routing
- Gateway
- ARP / Neighbor table
- ICMP
- TCP
- Ports
- SSH
- DNS
- HTTP
- HTTPS
- TLS
- curl

## Commands Practiced

```bash
ip -br addr
ip route
ip route get <IP>
ip neigh
ping
ss -lntup
nc -zv <HOST> <PORT>
ssh -p <PORT> user@host
getent hosts <DOMAIN>
curl -I <URL>
curl -v <URL>