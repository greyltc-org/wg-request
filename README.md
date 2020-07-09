# wg-request
a tool to help you with wireguard client peer provisioning, exchanges public keys and kinda manages IP addresses  
`join-wg.sh` -- client side bash script  
`wg-request` -- the tool (python script)

## Usage
### Server
Imagine you're person A, and you're running a wireguard peer that you'd like to act as a traditional VPN server. You know your public key for that peer is `RNveEHSE4Ky+4X0aybFz5W42NAIvTv+GB4iSv3UAZAM=`. Also imagine you have an address space available for new client peers to join your network that begins at 10.32.3.4. You should run:
```bash
$ ./wg-request --serve RNveEHSE4Ky+4X0aybFz5W42NAIvTv+GB4iSv3UAZAM= 10.32.3.4
Wireguard request server started listening on port 43454
```

### Client
Now imagine you're person B, and you'd like to request to join your wireguard peer to the network that person A is running. You know your public key is `Wpu83JMdnaJVGsrZeOJ4PZbdajRXzE0KVhLcvGEXLBg=` and you also know that person A's server is running at wireguardvpnserver.motorcycles. You should run:
```bash
$ ./wg-request Wpu83JMdnaJVGsrZeOJ4PZbdajRXzE0KVhLcvGEXLBg= wireguardvpnserver.motorcycles
[Interface]
Address = 10.32.3.4/24

[Peer]
PublicKey = RNveEHSE4Ky+4X0aybFz5W42NAIvTv+GB4iSv3UAZAM=
Endpoint = wireguardvpnserver.motorcycles:15820
```
:tada: Look what you got back! A configuration snippet you can use to configure your peer to join person A's network! Let's hope they let you in!

### Server
Now imagine you're person A again. You look at your terminal and see someone has requested to join your network:
```bash
$ ./wg-request --serve RNveEHSE4Ky+4X0aybFz5W42NAIvTv+GB4iSv3UAZAM= 10.32.3.4
Wireguard request server started listening on port 43454
Accepted new connection: <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('25.8.170.217', 43454), raddr=('55.15.100.23', 60358)> from ip ('55.15.100.23', 60358)
Someone sent us 44 bytes @ 2020-06-16 09:23:45.007359
[Peer]
# who?
PublicKey = Wpu83JMdnaJVGsrZeOJ4PZbdajRXzE0KVhLcvGEXLBg=
AllowedIPs = 10.32.3.4/24
```
Maybe you see enough info there to decide if you want to configure your peer to let them join.
