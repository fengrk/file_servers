#!/bin/bash
# install ss
sudo apt update && sudo apt upgrade -y && sudo apt install shadowsocks
echo '{
"server":"0.0.0.0",
"server_port":6379,
"local_port":1080,
"password":"passwd",
"timeout":600,
"method":"aes-256-cfb",
"local_address":"127.0.0.1",
"fast_open":true,
"tunnel_remote":"8.8.8.8",
"dns_server":["8.8.8.8", "8.8.4.4"],
"tunnel_remote_port":53,
"tunnel_port":53
}' > ~/ss.config && sudo ssserver -c ~/ss.config -d start

# open BBR
sudo modprobe tcp_bbr 
echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf

# 优化吞吐量: ssserver 未配置
echo '
# max open files
fs.file-max = 51200
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096

# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# turn on TCP Fast Open on both client and server side
net.ipv4.tcp_fastopen = 3
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

net.ipv4.tcp_congestion_control = bbr
' | sudo tee /etc/sysctl.d/local.conf
sysctl --system
