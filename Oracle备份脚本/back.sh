!/bin/sh
source /home/oracle/.bash_profile
dateTime=`date +%Y_%m_%d` #当前系统时间
days=7 #删除7天前的备份数据s
orsid='127.0.0.1:1521/orcl' #oralce连接信息
orowner=sys # 备份此用户下面的数据
bakuser=sys #用此用户来执行备份，必须要有备份操作的权限
bakpass=oracle #执行备注的用户密码
bakdir=/DATA/bakorcldata/moodle #备份文件路径，需要提前创建好
USERID="/as sysdba"
bakdata=$orowner"_"$dateTime.dmp #备份数据库保存的名称
baklog=$orowner"_"$dateTime.log #备份执行时候生成的日志文件名称
ordatabak=$orowner"_"$dateTime.tar.gz #最后保存的Oracle数据库备份文件
#以下代码为要放置备份文件的远程机的信息
#远程服务器地址
remoteip=10.121.2.29
#上传到远程服务器的路径
remotePath=/opt
#远程服务器用户名
remoteuser=root
#远程服务器密码
remotepass=123456
cd $bakdir #进入备份目录
mkdir -p $orowner #按需要备份的Oracle用户创建目录
cd $orowner #进入目录
find $bakdir/$orowner -type f -name "*.log" -exec rm {} \; #删除日志文件
find $bakdir/$orowner -type f -name "*.dmp" -exec rm {} \; #删除备份文件
#exp $bakuser/$bakpass@$orsid grants=y owner=$orowner file=$bakdir/$orowner/$bakdata log=$bakdir/$orowner/$baklog #执行备份
#exp /'as sysdba/' grants=y owner=$orowner file=$bakdir/$orowner/$bakdata log=$bakdir/$orowner/$baklog
expdp \"'sys/oracle as sysdba'\" grants=y owner=$orowner file=$bakdir/$orowner/$bakdata log=$bakdir/$orowner/$baklog
tar -zcvf $ordatabak $bakdata $baklog #压缩备份文件和日志文件
find $bakdir/$orowner -type f -name "*.log" -exec rm {} \; #删除日志文件
find $bakdir/$orowner -type f -name "*.dmp" -exec rm {} \; #删除备份文件
find $bakdir/$orowner -type f -name "*.tar.gz" -mtime +$days -exec rm -rf {} \; #删除7天前的备份（注意：{} \中间有空格）
scp -o StrictHostKeyChecking=no -r $bakdir/$orowner/$ordatabak $remoteuser@$remoteip:$remotePath  #将备份文件上传到远程服务器
