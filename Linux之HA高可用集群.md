---
title: Redhat HA高可用集群架设
date: 2017-12-26 20:32:45
---

echo '192.168.8.100 node001' >> /etc/hosts
echo '192.168.8.101 node002' >> /etc/hosts
echo '192.168.8.102 node003' >> /etc/hosts


ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''



ssh-copy-id -i ~/.ssh/id_rsa.pub node002 	

clustat -i 1
clusvcadm -d 88
clusvcadm -e 88

chkconfig cman on
chkconfig ricci on
chkconfig luci on
chkconfig rgmanager on
chkconfig modclusterd on
chkconfig clvmd on


