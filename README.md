# docker-wireguard

A Docker container for using WireGuard with a pre-configured wireguard config file.

## Requirements
* Ideally the host must already support WireGuard. Pre 5.6 kernels may need to have the module manually installed. If this is not possible, then a userspace implementation

## Config
| ENV Var | Function |
|-------|------|
|```LOCAL_NETWORK=192.168.1.0/24```|Whether to route and allow input/output traffic to the LAN. LAN access is blocked by default if not specified. Multiple ranges can be specified, separated by a comma or space.
|```KEEPALIVE=25```|If defined, PersistentKeepalive will be set to this in the WireGuard config.
|```VPNDNS=8.8.8.8, 8.8.4.4```|Use these DNS servers in the WireGuard config. Defaults to the VPN endpoint's DNS servers if not specified.
|```FIREWALL=0/1```|Whether to block non-WireGuard traffic. Defaults to 1 if not specified.
|```EXIT_ON_FATAL=0/1```|There is no error recovery logic at this stage. If something goes wrong we simply go to sleep. By default the container will continue running until manually stopped. Set this to 1 to force the container to exit when an error occurs. Exiting on an error may not be desirable behaviour if other containers are sharing the connection.
|```WG_USERSPACE=0/1```|If the host OS or host Linux kernel does not support WireGuard (certain NAS systems), a userspace implementation ([wireguard-go](https://git.zx2c4.com/wireguard-go/about/)) can be enabled. Defaults to 0 if not specified.
|```PEER_PORT=51820```|The port that the wireguard servers are listening on; not sure if this is even needed. Leaving it anyway.

## Usage
### In progress
**Please use the included docker-compose.yaml file for now**

## Notes
* Be sure to mount your wireguard config file in the /etc/wireguard directory. ex:```docker run -v $PWD/wg0.conf:/etc/wireguard```...
* IPv4 only. IPv6 traffic is blocked unless using ```FIREWALL=0``` but you may want to disable IPv6 on the container anyway.
* An example [docker-compose.yml](https://github.com/pyunramura/docker-wireguard/blob/main/docker-compose.yaml) is included.
* An example Kubernetes [deployment.yml](https://github.com/pyunramura/docker-wireguard/blob/main/deployment.yaml) is also included.
* Other containers can share the VPN connection using Docker's [```--net=container:xyz```](https://docs.docker.com/engine/reference/run/#network-settings) or docker-compose's [```network_mode: service:xyz```](https://github.com/compose-spec/compose-spec/blob/master/spec.md#network_mode).
* The userspace implementation through wireguard-go is very stable but lacks in performance. Looking into supporting ([boringtun](https://github.com/cloudflare/boringtun)) might be beneficial.

## Credits
Most of this container was copied from:
* https://github.com/thrnz/docker-wireguard-pia

Some bits and pieces and ideas have been borrowed from the following:
* https://github.com/activeeos/wireguard-docker
* https://github.com/cmulk/wireguard-docker
* https://github.com/dperson/openvpn-client
* https://gist.github.com/triffid/da48f3c99f1ff334571ae49be80d591b
* https://stackoverflow.com/a/54595564