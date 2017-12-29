#!/bin/sh
dateTime=`date +%Y_%m_%d` #当前系统时间
gzdays=7 #删除7天前的备份数据
snapdays=7 #删除7天前的快照数据
sdir=/app1/tomcat7_2.1/webapps/ROOT #
bakdir=/localbackdir #本地备份文件路径，需要提前创建好

#远程服务器地址
remoteip=10.121.4.1
#上传到远程服务器的路径
remotePath=/opt/Backupdir
#远程服务器用户名
remoteuser=root
#远程服务器密码
remotepass=123456


cd $bakdir #进入备份源目录目录
tar -g /$bakdir/snapshot_data.snap -zcpf /$bakdir/$dateTime.tar.gz --exclude-from=/$bakdir/exclude.list /$sdir

find $bakdir -type f -name "*.tar.gz" -mtime +$gzdays -exec rm -rf {} \; #删除7天前的备份（注意：{} \中间有空格）
find $bakdir -type f -name "*.snap" -mtime +$snapdays -exec rm -rf {} \; #删除7天前的快照数据（注意：{} \中间有空格）
#scp $bakdir/$dateTime.tar.gz $remoteuser@$remoteip:$remotePath #将备份文件上传到远程服务器