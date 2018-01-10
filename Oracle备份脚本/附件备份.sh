#!/bin/sh
#以下为备份所需的变量信息设置
dateTime=`date +%Y_%m_%d` #当前系统时间
gzdays=7 #删除7天前的备份数据
snapdays=7 #删除7天前的快照数据
sdir=/app1/tomcat7_2.1/webapps/ROOT #要备份的源目录路径
bakdir=/localbackdir #本地备份文件路径，需要提前创建好
remoteip=10.121.4.1 #远程服务器地址
remotePath=/opt/Backupdir #上传到远程服务器的路径
remoteuser=root #远程服务器用户名
remotepass=123456 #远程服务器密码

#以下代码为执行脚本
cd $bakdir #进入备份源目录目录
tar -g /$bakdir/snapshot_data.snap -zcpf /$bakdir/$dateTime.tar.gz --exclude-from=/$bakdir/exclude.list /$sdir #备份命令,exclude.list文档中放置备份所排除的目录路径
find $bakdir -type f -name "*.tar.gz" -mtime +$gzdays -exec rm -rf {} \; #删除7天前的备份（注意：{} \中间有空格）
find $bakdir -type f -name "*.snap" -mtime +$snapdays -exec rm -rf {} \; #删除7天前的快照数据（注意：{} \中间有空格）
#scp $bakdir/$dateTime.tar.gz $remoteuser@$remoteip:$remotePath #将备份文件上传到远程服务器