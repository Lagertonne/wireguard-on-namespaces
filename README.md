# Wireguard on Namespaces

## Purpose 
I want some applications to see just a specific (VPN) Interface. Instead of some iptables-Vodoo i decided to use Network Namespaces.

## Usage

There are some scripts here which should be in the right place

### create-ns.sh

Location: `/usr/local/sbin/create-ns.sh`

Purpose: Create the desired namespace. Will be called by a systemd-Unit. It will also create a veth-Interface to handle communication in and out the namespace. The IP in the container is `10.147.143.2/24`, on the host `10.147.143.1/24`

Configuration needed: None, if you are happy wit the IPs and the Namespace-Name "vpn".

### create-ns-vpn.service

Location: `/etc/systemd/system/create-ns-vpn.service`

Purpose: Creates the namespace on boot, if enabled. Deletes the namespace when stopped (i.e. on shutdown)

Configuration: No.

### wireguard-vpn.conf

Location: `/etc/wireguard/wireguard-vpn.conf`

Purpose: Wireguard Config for the VPN you want to connect to. There should be no need to add further Configuration-Parameters here in a simple setup. IPs will be assigned by `up-netns.sh`

Configuration needed: You have to adjust the lines `PrivateKey =`, `PublicKey = ` and `Endpoint =` 

### up-netns.sh

Location: `/etc/wireguard/up-netns.sh`

Purpose: Assign IP-Addresses to the wireguard-Interface and move it to the Network-Namespace. Make the Wireguard-Interface the default gateway inside the Namespace.

Configuration needed: No.

### wg-netns.service

Location: `/etc/systemd/system/wg-netns.service`

Purpose: Bring the wireguard-Interface up by calling up-netns.sh

Configuration needed: You have to adjust the IP-Addresses to your needs. In the example, I used `10.1.1.10/32` and `fe80::3/128`. Those will probably not work in your Wireguard-Setup. Also, if you want to use a different Network-Namespace-Name than "vpn", you have to adjust it here in the second Argument of the `up-netns.sh` call.
