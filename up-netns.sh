#!/bin/bash

WGNAME=$1
NETNS=$2
IP4=$3
IP6=$4

if [[ -z $WGNAME || -z $NETNS || -z $IP4 || -z $IP6 ]]
then
	echo "Usage:"
	echo "up-netns.sh <WGNAME> <NETNS> <IPv4> <IPv6>"
	exit 1
fi

ip link add $WGNAME type wireguard
ip link set $WGNAME netns $NETNS
ip -n $NETNS addr add $IP4 dev $WGNAME
ip -n $NETNS addr add $IP6 dev $WGNAME
ip netns exec $NETNS wg setconf $WGNAME /etc/wireguard/${WGNAME}.conf
ip -n $NETNS link set $WGNAME up
ip -n $NETNS route add default dev $WGNAME

