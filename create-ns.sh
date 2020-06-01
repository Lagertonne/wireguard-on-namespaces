#!/bin/sh

NS_NAME="vpn"

ip netns add $NS_NAME
ip netns exec $NS_NAME ip link set dev lo up

ip link add $NS_NAME-veth1 type veth peer name $NS_NAME-veth2
ip link set $NS_NAME-veth2 netns $NS_NAME

ip addr add 10.147.143.1/24 dev $NS_NAME-veth1
ip link set $NS_NAME-veth1 up
ip netns exec $NS_NAME ip addr add 10.147.143.2/24 dev $NS_NAME-veth2
ip netns exec $NS_NAME ip link set $NS_NAME-veth2 up
