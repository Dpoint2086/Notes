RedHat 6版本安装Oracle 12.2
=======================
2017/11/15     **By Skynet**

----------
### 系统及软件版本 ###
* Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production
* Red Hat Enterprise Linux Server release 6.5 (Santiago)

**Linux发行版本查看**
方式一

    cat /etc/issue
方式二

    lsb_release -a
方式三 (仅针对redhat，Fedora)

    cat /etc/redhat-release

### 所用工具 ###
* [PLSQL Developer V12 X64](http://xxx1.gd.xdowns.com/2017/PLSQLDeveloper.rar)
* [Navicat premium ](https://www.baidu.com/s?ie=utf-8&f=3&rsv_bp=1&tn=87048150_dg&wd=navicat%20premium%20%E7%A0%B4%E8%A7%A3%E7%89%88&oq=Navicat%2520premium%2520v11.2.1%2526lt%253B&rsv_pq=d0da0a8d0001248c&rsv_t=6f2eeSA9d5csd2G09W%2FcFcp96f%2BjiIeXyMGbR36TWPxlvoHMEwAqcccznyeRMQHXJ0g&rqlang=cn&rsv_enter=1&inputT=1440&rsv_sug3=3&rsv_sug1=1&rsv_sug7=100&rsv_sug2=1&prefixsug=Navicat%2520premium%2520&rsp=2&rsv_sug4=1441&rsv_sug=1) 
* [Xmanager.Enterprise.v5.1236](http://u.vip.rapidsave.org/dl6/o-5/p16171929/201758135533_268199.rar)
* [Oracle 12.2.0.1.0 OCI文件](http://download.oracle.com/otn/nt/instantclient/122010/instantclient-basic-windows.x64-12.2.0.1.0.zip)
* [Oracle Instant Client所有平台及版本下载](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)

----------

## Linux基础环境配置 ##
### 配置网卡IP地址及DNS ###
> vi /etc/sysconfig/networ-scripts/ifcfg-eth0

    DEVICE=eth0
    HWADDR=00:0C:29:70:48:34
    TYPE=Ethernet
    UUID=361d2575-c1f7-4f22-bab0-0edfa5e9da73
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=static
    IPADDR=10.121.2.29
    NETMASK=255.255.255.0
    GATEWAY=10.121.2.254
    DNS1=114.114.114.114
    DNS2=114.114.115.115
    
测试网络解析及连接是否正常
> ping qq.com

### hostname配置 ###
hostname配置不正解或不一致,安装oracle时会报**prvf-0002**故障
hostname 修改后立即生效(新会话窗口)
修改network需重启后生效

	hostname DBServer
	vim /etc/sysconfig/network
[参考资料:linux hostname深入理解](https://www.cnblogs.com/kerrycode/p/3595724.html)

### 删除Redhat系统自带YUM  ###

查询

`rpm -qa|grep yum` 
 
删除

`rpm -qa |grep yum |xargs rpm -e --nodeps`

###下载安装YUM安装文件并配置###
(1/3): openssl-1.0.1e-57.el6.x86_64.rpm                                                                                                                             | 1.5 MB     00:01     
(2/3): python-2.6.6-66.el6_8.x86_64.rpm                                                                                                                             |  76 kB     00:00     
(3/3): python-libs-2.6.6-66.el6_8.x86_64.rpm 

    cd /etc/yum.repos.d/
    wget -P /etc/yum.repos.d/ http://mirrors.163.com/.help/CentOS6-Base-163.repo
    mv rhel-source.repo rhel-source.repo.bak
    mv packagekit-media.repo packagekit-media.repo.bak
    
    mkdir -p /etc/yum.repos.d/yumpackage
    cd /etc/yum.repos.d/yumpackage
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-2.6.6-66.el6_8.x86_64.rpm
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-libs-2.6.6-66.el6_8.x86_64.rpm
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-iniparse-0.3.1-2.1.el6.noarch.rpm
    
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.30-40.el6.noarch.rpm
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-3.2.29-81.el6.centos.noarch.rpm
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-urlgrabber-3.9.1-11.el6.noarch.rpm
    
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/screen-4.0.3-19.el6.x86_64.rpm

### Yum Install ###

	rpm -Uvh python-2.6.6-66.el6_8.x86_64.rpm python-libs-2.6.6-66.el6_8.x86_64.rpm python-iniparse-0.3.1-2.1.el6.noarch.rpm
	rpm -Uvh yum-3.2.29-81.el6.centos.noarch.rpm yum-metadata-parser-1.1.2-16.el6.x86_64.rpm yum-plugin-fastestmirror-1.1.30-40.el6.noarch.rpm python-urlgrabber-3.9.1-11.el6.noarch.rpm

###替换Yum配置文件版本号###

	cd ..
	vi CentOS6-Base-163.repo
`%s/$releasever/6/g`


>%s/源字符串/目的字符串/g

### Yum初始化（并安装vim测试） ###

	yum clean all
	yum makecache
	yum install vim

# Oracle R12.2 Install #

----------

## Checking Hardware and Memory Configuration ##

	grep SwapTotal /proc/meminfo
	free
	df -h
	df -h /tmp
	grep MemTotal /proc/meminfo


Oracle installer prepare
------------------------
* [安装检查参考](https://docs.oracle.com/database/121/LADBI/chklist.htm#LADBI8045)
* [**安装过程Troubleshooting**](https://docs.oracle.com/database/121/LADBI/app_ts.htm#LADBI7939)
* [安装过程参考](https://www.cnblogs.com/kerrycode/archive/2013/09/13/3319958.html)
* [Swap分区调整参考](http://blog.itpub.net/29440247/viewspace-1445502/)

### SoftWare Install ###

**Linux7**

`yum install binutils ksh compat-libcap1 compat-libstdc++* gcc gcc-c++ glibc.i686 glibc.x86_64 glibc-dev* libaio* libgcc* libstdc++* libXi.* libXtst.* make sysstat`


**Linux6**

	yum install binutils ksh compat-libcap1 compat-libstdc++* gcc gcc-c++ glibc.i686 glibc.x86_64 glibc-dev* libaio* libgcc* libstdc++* libXi.* libXtst.* make sysstat
	yum install libXau libxcb libXi libXext

**Linux5**

	yum install binutils ksh coreutils compat-libstdc++* gcc gcc-c++ glibc.i686 glibc.x86_64 glibc-dev* libaio* libgcc* libstdc++* libXi.* libXtst.* make sysstat
	yum install libXau libXi libXext

### Create Groups and Users ###

	groupadd oinstall
	groupadd oracle
	useradd -g oinstall -G oracle oracle

> 修改命令
> 
> `usermod -g oinstall -G oracle`
	
### 建立文件目录并赋权 ###

	mkdir -p /u01/app/oracle
	mkdir -p /u01/app/oraInventory
	chown -R  oracle:oinstall /u01/app
	chmod -R 775 /u01/app

### 配置用户变量 ###

设置用户密码

	passwd oracle
	ygct@666888

配置安装文件权限**(在执行赋权命令前,请将oracle安装文件在database目录下)**
    mkdir -p /opt/database
    chmod -R 775 /opt/database

配置oracle用户变量
**注意修改**ORACLE_SID=**ORCL**;
> vim ~oracle/.bash_profile

	umask 022
    TMP=/tmp; export TMP
    TMPDIR=$TMP; export TMPDIR
    ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
    ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1; export ORACLE_HOME
    ORACLE_SID=ORCL; export ORACLE_SID
    ORACLE_TERM=xterm; export ORACLE_TERM
    PATH=/usr/sbin:$PATH; export PATH
    PATH=$ORACLE_HOME/bin:$PATH; export PATH
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
    CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH


## 开始安装 ##
**请以Oracle用户登录到SSH,不能使用SU命令进行切换**

查看用户变量

**请以Oracle用户运行**

	umask
	env | more

## 运行安装程序 ##
**请以Oracle用户运行**

    cd /opt/database/
    ./runInstaller

运行以上命令后 后弹出Oracle安装图形界面.
请在图形界面进行安装环境的检查,检查完后请点击**Check&FIX**

然后**请以Root用户**执行以下脚本进行修复


> /tmp/CVU_12.2.0.1.0_oracle/runfixup.sh

修复完成后再次运行检查程序,直至没有错误及警告产生.

## 结束脚本运行 ##
**请以Root用户运行以下脚本**

> /u01/app/oraInventory/orainstRoot.sh
> 
> /u01/app/oracle/product/12.1.0/db_1/root.sh



> Enter the full pathname of the local bin directory: [/usr/local/bin]: 
> /usr/local/bin


# 安装完成 #
安装完成后,Oracle数据库已经为启动状态,请不要再次启用.

如再次启动时会出现出下错误:
> SQLstartup
> ORACLE instance started.
> 
> Total System Global Area 3758096384 bytes
> Fixed Size		8627392 bytes
> Variable Size		  872418112 bytes
> Database Buffers	 2868903936 bytes
> Redo Buffers		8146944 bytes
> ***ORA-01102: cannot mount database in EXCLUSIVE mode***

### 解决方法 ###


* 关闭这个未完全启动的数据库
使用oracle帐号登录SSH,执行如下命令

    sqlplus "/as sysdba"
    shutdown immediate;
    
输出
> SQL> shutdown immediate;
> ORA-01507: database not mounted
> ORACLE instance shut down.




* 查找dbs目录,找到lkORCL文件
这个目录随不同的安装过程,可能出现在不同的地方,有的时候在oracle账户的home目录下,有时出现在$ORACLE_HOME下


    [oracle@oracle ~]$ cd $ORACLE_HOME
    [oracle@oracle db_1]$ cd dbs
    [oracle@oracle dbs]$ ls
    hc_orcl.dat  initdw.ora  init.ora  lkORCL  orapworcl  spfileorcl.ora
执行下列命令查找锁定lkORCL文件的进程

    fuser -u lkORCL
执行下列命令终止进程   
 
    fuser -k lkORCL
重新启动数据库

    sqlplus / as sysdba
    startup;
    
查看数据库状态 *OPEN_MODE* 为 **READ WRITE**


    select open_mode from v$database;
    
## 配置Oracle监听(直接安装时建库无需配置) ##

`cd /u01/app/oracle/product/12.1.0/db_1/network/admin`

查看监听状态

`ps -ef | grep tnslsnr`

### Oracle自动生成的监听配置 ###

#### listener.ora ####

    # listener.ora Network Configuration File: /u01/app/oracle/product/12.1.0/db_1/network/admin/listener.ora
    # Generated by Oracle configuration tools.

    LISTENER =
      (DESCRIPTION_LIST =
        (DESCRIPTION =
          (ADDRESS = (PROTOCOL = TCP)(HOST = yghttest)(PORT = 1521))
          (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
        )
      )

#### tnsnames.ora ####

    # tnsnames.ora Network Configuration File: /u01/app/oracle/product/12.1.0/db_1/network/admin/tnsnames.ora
    # Generated by Oracle configuration tools.

    LISTENER_ORCL =
      (ADDRESS = (PROTOCOL = TCP)(HOST = yghttest)(PORT = 1521))


    ORCL =
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = yghttest)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = ORCL)
        )
      )

#### sqlnet.ora ####

    # sqlnet.ora Network Configuration File: /u01/app/oracle/product/12.1.0/db_1/network/admin/sqlnet.ora
    # Generated by Oracle configuration tools.

    NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)



### 手工配置监听 ###

#### 动态监听时 ####
	SID_LIST_LISTENER =
	 (SID_LIST =
	  (SID_DESC =
	   (SID_NAME = PLSExtProc)
		(ORACLE_HOME = /u01/app/oracle/product/12.1.0/db_1)
		 (PROGRAM=extproc)
	  )
	 )

	LISTENER =
	 (DESCRIPTION =
	  (ADDRESS_LIST =
	   (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
	  )
	 )


####静态监听(注意更改SID)####
	LISTENER =
	 (DESCRIPTION =
	  (ADDRESS_LIST =
		(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
			(ADDRESS=(PROTOCOL=ipc)(KEY=extproc))
	  )
	)

	SID_LIST_LISTENER =
	 (SID_LIST =
	# (SID_DESC =
		# (SID_NAME = PLSExtProc)
			# (ORACLE_HOME = /u01/app/oracle/product/12.1.0/db_1)
				# (PROGRAM=extproc)
	# )
	  (SID_DESC =
		(GLOBAL_DBNAME = gdyght)
			(ORACLE_HOME = /u01/app/oracle/product/12.1.0/db_1)
				(SID_NAME=gdyght)
	 )
	)
	  
**重启监听**

`tnslsnr reload`

`tnslsnr stop`

`tnslsnr start`

 https://yghtdb:5500/em

其它内容
--

**SCP从远程拉取数据库安装文件到本地**

	scp -r root@10.121.2.29:/usr/local/database /opt/datebase

**Screen使用说明**

>screen -S yourname -> 新建一个叫yourname的session  
screen -ls -> 列出当前所有的session  
screen -r yourname -> 回到yourname这个session  
screen -d yourname -> 远程detach某个session  
screen -d -r yourname -> 结束当前session并回到yourname这个session

----------
