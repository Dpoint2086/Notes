---
title: Linux之时间服务器配置
date: 2017-12-26 20:32:45
---


服务器配置
=====

系统环境配置
---

保存以下参数到**ntp.sh**,以root用户执行.
> chmod +x ntp.sh

    #!/bin/sh
    rm /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo 'ZONE="Asia/Shanghai"' >/etc/timezone
    echo 'UTC=false' >>/etc/timezone
    echo 'ARC=false' >>/etc/timezone
    echo 'ntpdate -bu 115.28.122.198' >>/etc/rc.local
    echo 'ntpdate -bu 172.255.246.13' >>/etc/rc.local
    echo 'ntpdate -bu 85.199.214.101' >>/etc/rc.local
    echo 'ntpdate -bu 85.199.214.100' >>/etc/rc.local

NTP服务器配置 
---

> vim /etc/ntp.conf

    # NTP Network Time Protocol
    # **** ATTENTION ****: *You have to restart the NTP service when you change this file to activate the changes*
    # PLEASE CHECK THIS FILE CAREFULLY AND MODIFY IT IF REQUIRED
    # Configuration File created by Windows Binary Distribution Installer Rev.: 1.27  mbg
    # please check http://www.ntp.org for additional documentation and background information
    # restrict access to avoid abuse of NTP for traffic amplification attacks
    # see http://news.meinberg.de/244 for details 
    restrict default noquery nopeer nomodify notrap 
    restrict -6 default noquery nopeer nomodify notrap
     
    # allow status queries and everything else from localhost
    restrict 127.0.0.1
    restrict -6 ::1
    restrict 0.0.0.0 netmask 0.0.0.0 nomodify nopeer
     
    # if you need to allow access from a remote host, you can add lines like this:
    # restrict <IP OF REMOTE HOST>
     
    # Use drift file
    driftfile /var/lib/ntp/ntp.drift
    # your local system clock, should be used as a backup
    # (this is only useful if you need to distribute time no matter how good or bad it is)
    server 127.127.1.0
    # but it operates at a high stratum level to let the clients know and force them to
    # use any other timesource they may have.
    fudge 127.127.1.0 stratum 3
    # Use a NTP server from the ntp pool project (see http://www.pool.ntp.org)
    # Please note that you need at least four different servers to be at least protected against
    # one falseticker. If you only rely on internet time, it is highly recommended to add
    # additional servers here.
    # The 'iburst' keyword speeds up initial synchronization, please check the documentation for more details!
    
    server	108.59.2.24	minpoll 6 maxpoll 9 iburst
    server	115.28.122.198	minpoll 6 maxpoll 9 iburst
    server	163.172.177.158	minpoll 6 maxpoll 9 iburst
    server	173.255.246.13	minpoll 6 maxpoll 9 iburst
    server	193.228.143.22	minpoll 6 maxpoll 9 iburst
    server	202.112.10.36	minpoll 6 maxpoll 9 iburst
    server	202.112.29.82	minpoll 6 maxpoll 9 iburst
    server	202.118.176.2	minpoll 6 maxpoll 9 iburst
    server	203.135.184.123	minpoll 6 maxpoll 9 iburst
    server	212.47.249.141	minpoll 6 maxpoll 9 iburst
    server	61.216.153.106	minpoll 6 maxpoll 9 iburst
    server	85.199.214.100	minpoll 6 maxpoll 9 iburst
    server	85.199.214.101	minpoll 6 maxpoll 9 iburst
    
    # End of generated ntp.conf --- Please edit this to suite your needs
    SYNC_HWCLOCK=yes





客户端配置
=======

保存以下参数到**ntp.sh**,以root用户执行.
> chmod +x ntp.sh

    #!/bin/sh
    rm -f /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo 'ZONE="Asia/Shanghai"' >/etc/timezone
    echo 'UTC=false' >>/etc/timezone
    echo 'ARC=false' >>/etc/timezone
    echo 'ntpdate -bu 10.121.4.71' >>/etc/rc.local
    rm -f /etc/ntp.conf
    wget -P /etc/ http://10.121.4.100/ntp.conf

客户端配置文件
---

> vim /etc/ntp.conf

    #normal node
    # For more information about this file, see the man pages
    # ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).
    
    driftfile /var/lib/ntp/drift
    
    # Permit time synchronization with our time source, but do not
    # permit the source to query or modify the service on this system.
    restrict default nomodify
    restrict -6 default kod nomodify notrap nopeer noquery
    
    # Permit all access over the loopback interface.  This could
    # be tightened as well, but to do so would effect some of
    # the administrative functions.
    restrict 127.0.0.1 
    restrict -6 ::1
    
    # Hosts on local network are less restricted.
    #restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
    
    # Use public servers from the pool.ntp.org project.
    # Please consider joining the pool (http://www.pool.ntp.org/join.html).
    
    #broadcast 192.168.1.255 autokey	# broadcast server
    #broadcastclient			# broadcast client
    #broadcast 224.0.1.1 autokey		# multicast server
    #multicastclient 224.0.1.1		# multicast client
    #manycastserver 239.255.254.254		# manycast server
    #manycastclient 239.255.254.254 autokey # manycast client
    
    # Undisciplined Local Clock. This is a fake driver intended for backup
    # and when no outside source of synchronized time is available. 
    
    server 10.121.4.71 prefer minpoll 6 maxpoll 9 iburst
    server 127.127.1.0
    #fudge 127.127.1.0 stratum 10
    
    # Enable public key cryptography.
    #crypto
    
    includefile /etc/ntp/crypto/pw
    
    # Key file containing the keys and key identifiers used when operating
    # with symmetric key cryptography. 
    keys /etc/ntp/keys
    
    # Specify the key identifiers which are trusted.
    #trustedkey 4 8 42
    
    # Specify the key identifier to use with the ntpdc utility.
    #requestkey 8
    
    # Specify the key identifier to use with the ntpq utility.
    #controlkey 8
