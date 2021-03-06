# Born2beroot

## Table of Contents
1. [Installation](#installation)
2. [*sudo*](#sudo)
    - [Step 1: Installing *sudo*](#step-1-installing-sudo)
    - [Step 2: Adding User to *sudo* Group](#step-2-adding-user-to-sudo-group)
    - [Step 3: Running *root*-Privileged Commands](#step-3-running-root-privileged-commands)
    - [Step 4: Configuring *sudo*](#step-4-configuring-sudo)
3. [SSH](#ssh)
    - [Step 1: Installing & Configuring SSH](#step-1-installing--configuring-ssh)
    - [Step 2: Installing & Configuring UFW](#step-2-installing--configuring-ufw)
    - [Step 3: Connecting to Server via SSH](#step-3-connecting-to-server-via-ssh)
4. [User Management](#user-management)
    - [Step 1: Setting Up a Strong Password Policy](#step-1-setting-up-a-strong-password-policy)
       - [Password Age](#password-age)
       - [Password Strength](#password-strength)
    - [Step 2: Creating a New User](#step-2-creating-a-new-user)
    - [Step 3: Creating a New Group](#step-3-creating-a-new-group)
5. [Script-monitoring](#Script-monitoring)
6. [Bonus](#bonus)
    - [Installation](#1-installation)
    - [Linux Lighttpd MariaDB PHP *(LLMP)* Stack](#2-linux-lighttpd-mariadb-php-llmp-stack)
       - [Step 1: Installing Lighttpd](#step-1-installing-lighttpd)
       - [Step 2: Installing & Configuring MariaDB](#step-2-installing--configuring-mariadb)
       - [Step 3: Installing PHP](#step-3-installing-php)
       - [Step 4: Downloading & Configuring WordPress](#step-4-downloading--configuring-wordpress)
       - [Step 5: Configuring Lighttpd](#step-5-configuring-lighttpd)
    - [File Transfer Protocol *(FTP)*](#3-file-transfer-protocol-ftp)
       - [Step 1: Installing & Configuring FTP](#step-1-installing--configuring-ftp)
       - [Step 2: Connecting to Server via FTP](#step-2-connecting-to-server-via-ftp)

#### Для начала  также установим tmux и vim

    apt install tmux
    apt install vim
    
#### Эта утилита для разбивки консоли

* [Шпаргалка](https://losst.ru/shpargalka-po-tmux)


#### Первое должны совпадать разделы

## Команда для проверки разделов

    lsblk

## Она Показывает
    
    Название диска и разделов на нем.
    Тип файловой системы.
    Размер всего диска и размер каждого раздела.
    Точка монтирования и, если доступно, метка для них.


## *sudo*

### Step 1: Installing *sudo*
Переключитесь на root и его окружение через  `su -`.
```
$ su -
Password:
#
```
Установка *sudo* via `apt install sudo`.
```
# apt install sudo
```
Проверка успешной становки судо `dpkg -l | grep sudo`.
```
# dpkg -l | grep sudo
```

### Step 2: Adding User to *sudo* Group
Добавление пользователя в группу  *sudo* group via `adduser <username> sudo`.
```
# adduser <username> sudo
```
>Альтернативный способ `usermod -aG sudo <username>`.
>```
># usermod -aG sudo <username>
>```
Проверьте, был ли пользователь успешно добавлен в группу sudo с помощью `getent group sudo`.
```
$ getent group sudo
```
`reboot` чтобы изменения вступили в силу, затем войдите в систему и подтвердите полномочия sudo через sudo-v.
```
# reboot
<--->
Debian GNU/Linux 10 <hostname> tty1

<hostname> login: <username>
Password: <password>
<--->
$ sudo -v
[sudo] password for <username>: <password>
```

### Step 3: Running *root*-Privileged Commands
С этого момента запускайте *root*-привилегированные команды с помощью префикса `sudo`. Например:
```
$ sudo apt update
```
### Step 4: Configuring *sudo*
    
Подробней про sudo и su можно почитать тут https://losst.ru/nastrojka-sudo-v-linux    
    
Настройте  *sudo* через `sudo vim /etc/sudoers.d/<filename>`. `<filename>` не должно заканчиваться на `~` или содержать `.`
По этому пути будет файл конфигурации sudo
    
```
$ sudo vim /etc/sudoers.d/<filename>
```
Чтобы ограничить аутентификацию с помощью sudo до 3 попыток (по умолчанию в любом случае 3) в случае неправильного пароля, добавьте в файл строку ниже.
```
Defaults        passwd_tries=3
```
Чтобы добавить пользовательское сообщение об ошибке в случае неправильного пароля:
```
Defaults        badpass_message="<custom-error-message>"
```
###
Для записи логов всех команд *sudo*  `/var/log/sudo/<filename>`:
```
$ sudo mkdir /var/log/sudo
<~~~>
Defaults        logfile="/var/log/sudo/<filename>"
<~~~>
```
Для архивирования всех входов и выходов *sudo* в `/var/log/sudo/`:
```
Defaults        log_input,log_output
Defaults        iolog_dir="/var/log/sudo"
```
Требовать *TTY*:
```
Defaults        requiretty
```
To set *sudo* paths to `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`:
```
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
Еще всякое про sudo https://white55.ru/sudo.html
    
 ## SSH

### Step 1: Installing & Configuring SSH
Установка *openssh-server* с помощью `sudo apt install openssh-server`.
```
$ sudo apt install openssh-server
```
Проверить что пакеты успешно установились `dpkg -l | grep ssh`.
```
$ dpkg -l | grep ssh
```
Настройка файла конфигурации с помошью `sudo vim /etc/ssh/sshd_config`.
```
$ sudo vim /etc/ssh/sshd_config
```
Чтобы настроить SSH с использованием порта 4242, замените нижеприведенную строку:
```
13 #Port 22
```
на:
```
13 Port 4242
```
Чтобы отключить вход по SSH от имени *root* независимо от механизма аутентификации, замените нижеприведенную строку
```
32 #PermitRootLogin prohibit-password
```
на:
```
32 PermitRootLogin no
```
Проверка ssh `sudo service ssh status`.
```
$ sudo service ssh status
```
>В качестве альтернативы, проверьте статус SSH через `systemctl status ssh`.
>```
>$ systemctl status ssh
    ssh bmarilli@127.0.0.1 -p 4242
>```

### Step 2: Installing & Configuring UFW
Установка *ufw* c `sudo apt install ufw`.
```
$ sudo apt install ufw
```
Провкра что пакеты установились `dpkg -l | grep ufw`.
```
$ dpkg -l | grep ufw
```
Включение Firewall с помощью `sudo ufw enable`.
```
$ sudo ufw enable
```
Разрешить входящие соединения с использованием порта 4242 через `sudo ufw allow 4242`.
```
$ sudo ufw allow 4242
```
Проверка UFW status с помощью `sudo ufw status`.
```
$ sudo ufw status
```
[Почитать еще](https://1cloud.ru/help/security/ispolzovanie-utility-ufw-na-inux)
### Step 3: Connecting to Server via SSH
SSH в вашу виртуальную машину с помощью порта 4242 через `ssh <username>@<ip-address> -p 4242`.
```
$ ssh <username>@<ip-address> -p 4242
```
Завершите сеанс SSH в любое время с помощью `logout`.
```
$ logout
```
>В качестве альтернативы, завершите сеанс SSH с помощью `exit`.
>```
>$ exit
>```

## User Management

### Step 1: Setting Up a Strong Password Policy

#### Password Age
Настройте политику возраста пароля с помощью `sudo vim /etc/login.defs`.
```
$ sudo vim /etc/login.defs
```
Чтобы установить срок действия пароля каждые 30 дней, замените нижеприведенную строку
```
PASS_MAX_DAYS   99999
```
на:
```
PASS_MAX_DAYS   30
```
Чтобы установить минимальное количество дней между сменой пароля равным 2 дням, замените нижеприведенную строку
```
PASS_MIN_DAYS   0
```
на:
```
PASS_MIN_DAYS   2
```
Чтобы отправить пользователю предупреждающее сообщение за 7 дней * (по умолчанию в любом случае 7)* до истечения срока действия пароля, оставьте нижеприведенную строку как есть.
```
PASS_WARN_AGE   7
```

#### Password Strength
Во-вторых, чтобы настроить политики в отношении надежности пароля, установите пакет *libpam-pwquality*.
```
$ sudo apt install libpam-pwquality
```
Проверим установку `dpkg -l | grep libpam-pwquality`.
```
$ dpkg -l | grep libpam-pwquality
```
Настройте политику защиты пароля с помощью `sudo vim /etc/pam.d/common-password`, в частности, строка ниже:
```
$ sudo vim /etc/pam.d/common-password
<~~~>
password        requisite                       pam_pwquality.so retry=3
<~~~>
```
Чтобы установить минимальную длину пароля в 10 символов, добавьте опцию ниже в строку выше.
```
minlen=10
```
Требовать, чтобы пароль содержал по крайней мере символ верхнего регистра и числовой символ:
```
ucredit=-1 dcredit=-1
```
Чтобы установить максимум 3 последовательных одинаковых символа:
```
maxrepeat=3
```
Чтобы отклонить пароль, если он содержит "<имя пользователя>" в какой-либо форме:
```
reject_username
```
Чтобы установить количество изменений, необходимых для нового пароля, от старого пароля до 7:
```
difok=7
```
Для реализации той же политики в *root*:
```
enforce_for_root
```
Наконец, это должно выглядеть следующим образом:
```
password        requisite                       pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root
```
### Step 2: Creating a New User
Создайте нового пользователя с помощью `sudo adduser <username>`.
```
$ sudo adduser <username>
```
Проверьте, был ли пользователь успешно создан с помощью `getent passwd <username>`.
```
$ getent passwd <username>
```
Проверьте информацию об истечении срока действия пароля вновь созданного пользователя с помощью `sudo chage -l <username>`.
```
$ sudo chage -l <username>
Last password change					: <last-password-change-date>
Password expires					: <last-password-change-date + PASS_MAX_DAYS>
Password inactive					: never
Account expires						: never
Minimum number of days between password change		: <PASS_MIN_DAYS>
Maximum number of days between password change		: <PASS_MAX_DAYS>
Number of days of warning before password expires	: <PASS_WARN_AGE>
```
 Еще инфа https://itsecforu.ru/2019/02/18/%D0%BA%D0%B0%D0%BA-%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D0%B8%D1%82%D1%8C-%D0%BF%D0%BE%D0%BB%D0%B8%D1%82%D0%B8%D0%BA%D1%83-%D0%BD%D0%B0%D0%B4%D0%B5%D0%B6%D0%BD%D1%8B%D1%85-%D0%BF%D0%B0%D1%80%D0%BE/
    
### Step 3: Creating a New Group
Создайте новую *user42* с помощью `sudo addgroup user42`.
```
$ sudo addgroup user42
```
Добавьте пользователя в группу *user42* через`sudo adduser <username> user42`.
```
$ sudo adduser <username> user42
```
>Альтернатива *user42*  `sudo usermod -aG user42 <username>`.
>```
>$ sudo usermod -aG user42 <username>
>```
Проверим с помощью`getent group user42`.
```
$ getent group user42
```
## *Script-monitoring*
1.Вывод название системы(The architecture of your operating system and its kernel version.)
```
$ uname -a
```
2.The number of physical processors.
nproc - максимальное число процессов
```
$ nproc
```
3.The number of virtual processors
```
$ cat /proc/cpuinfo | grep processor | wc -l
```
4.The current available RAM on your server and its utilization rate as a percentage.
```
$ free -m | grep Mem | awk ' {printf "%d/%dMB (%.2f%%)\n",$3,$2, $3*100/$2} '
```
5.The current available memory on your server and its utilization rate as a percentage
```
$ df -k | grep root | awk '{ printf "%d",$3 / 1024} '
$ df -h | grep root | awk '{ printf "/%s (%s)\n",$2, $5} '    
```
6.The current utilization rate of your processors as a percentage.
```
$ cat /proc/loadavg  | awk '{ printf "%.1f%%" , $1}'
```
7.The date and time of the last reboot.
```
$ who -b | awk '{print $3 " " $4}'
```
8.Whether LVM is active or not.
```
$ lsblk | grep lvm  > /dev/null ; echo $? | awk ' {if ($1 == "0") print "yes"; else print "no"}'
```
9.• The number of active connections.
```
$ sudo apt install net-tools
$ netstat -an | grep ESTABLISHED | wc -l
```
10.The number of users using the server.
```
$ who | wc -l
```
11.The IPv4 address of your server and its MAC (Media Access Control) address
```
$ hostname -I
$ ip a | grep link/ether | awk '{print $2}'
```
12.The number of commands executed with the sudo program.
```
$ sudo cat sudo/sudo.log | grep COMMAND | wc -l
```

12.Cron
```
sudo crontab -u root -e
``` 
Чтобы запланировать запуск сценария оболочки каждые 10 минут, замените нижеприведенную строку
```
 # m h  dom mon dow   command
 */10 * * * *         bash /home/bmarilli/monitoring.sh
```
    
Проверьте запланированные задания cron root с помощью
    
```
$ sudo crontab -u root -l
```
## Bonus

### #1: Installation
Watch *bonus* installation walkthrough *(no audio)* [here](https://youtu.be/2w-2MX5QrQw).

### #2: Linux Lighttpd MariaDB PHP *(LLMP)* Stack

#### Step 1: Installing Lighttpd
Установка lighttpd (веб сервер)
```
$ sudo apt install lighttpd
```
Проверим то что все хорошо установилось
```
$ dpkg -l | grep lighttpd
```
Разрешить входящие соединения с использованием порта 80
```
$ sudo ufw allow 80
```
#### Step 2: Installing & Configuring MariaDB
Установка mariadb-server
```
$ sudo apt install mariadb-server
```
Проверка
```
$ dpkg -l | grep mariadb-server
```
Запустите интерактивный скрипт для удаления небезопасных настроек по умолчанию с помощью 
```
$ sudo mysql_secure_installation
Enter current password for root (enter for none): #Just press Enter (do not confuse database root with system root)
Set root password? [Y/n] n
Remove anonymous users? [Y/n] Y
Disallow root login remotely? [Y/n] Y
Remove test database and access to it? [Y/n] Y
Reload privilege tables now? [Y/n] Y
```
Заходим в мариадб
```
$ sudo mariadb
MariaDB [(none)]>
```
Создаем базу данных
```
MariaDB [(none)]> CREATE DATABASE <database-name>;
MariaDB [(none)]> CREATE DATABASE ifanzilka;
```
Создайте нового пользователя базы данных и предоставьте ему полные права доступа к вновь созданной базе данных с помощью
```
MariaDB [(none)]> GRANT ALL ON <database-name>.* TO '<username-2>'@'localhost' IDENTIFIED BY '<password-2>' WITH GRANT OPTION;
MariaDB [(none)]> GRANT ALL ON ifanzilka.*TO 'ifanzilka'@'localhost' IDENTIFIED BY 89639019932 WITH GRANT OPTION;
```
Сбросьте привилегии с помощью
```
MariaDB [(none)]> FLUSH PRIVILEGES;
```
Выходим из мариадб
```
MariaDB [(none)]> exit
```
Проверьте, был ли успешно создан пользователь базы данных, войдя в консоль MariaDB с помощью 
```
$ mariadb -u <username-2> -p
Enter password: <password-2>
MariaDB [(none)]>
```
Подтвердите, имеет ли пользователь базы данных доступ к базе данных с помощью
```
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| <database-name>    |
| information_schema |
+--------------------+
```
Выходи в шелл
```
MariaDB [(none)]> exit
```
#### Step 3: Installing PHP
Install *php-cgi* & *php-mysql* via `sudo apt install php-cgi php-mysql`.
```
$ sudo apt install php-cgi php-mysql
```
Verify whether *php-cgi* & *php-mysql* was successfully installed via `dpkg -l | grep php`.
```
$ dpkg -l | grep php
```

#### Step 4: Downloading & Configuring WordPress
Установим wget (Wget — (GNU Wget) свободная неинтерактивная консольная программа для загрузки файлов по сети. Поддерживает протоколы HTTP, FTP и HTTPS)
```
$ sudo apt install wget
```
Установим вордпресс в `/var/www/html` с `sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html`.
```
$ sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
```
Извлекать загруженный контент с помощью `sudo tar -xzvf /var/www/html/latest.tar.gz`.
```
$ sudo tar -xzvf /var/www/html/latest.tar.gz
```
Удалите архив с помощью `sudo rm /var/www/html/latest.tar.gz`.
```
$ sudo rm /var/www/html/latest.tar.gz
```
Копируем контент `/var/www/html/wordpress` в `/var/www/html` с помошью `sudo cp -r /var/www/html/wordpress/* /var/www/html`.
```
$ sudo cp -r /var/www/html/wordpress/* /var/www/html
```
Удаляем  `/var/www/html/wordpress` с помошью `sudo rm -rf /var/www/html/wordpress`
```
$ sudo rm -rf /var/www/html/wordpress
```
Создайте файл конфигурации WordPress из его образца с помощью `sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php`.
```
$ sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```
Настройте WordPress для ссылки на ранее созданную базу данных MariaDB и пользователя через `sudo vi /var/www/html/wp-config.php`.
```
$ sudo vim /var/www/html/wp-config.php
```
Замените нижеприведенное
```
23 define( 'DB_NAME', 'database_name_here' );^M
26 define( 'DB_USER', 'username_here' );^M
29 define( 'DB_PASSWORD', 'password_here' );^M
```
на:
```
23 define( 'DB_NAME', '<database-name>' );^M
26 define( 'DB_USER', '<username-2>' );^M
29 define( 'DB_PASSWORD', '<password-2>' );^M
```
#### Step 5: Configuring Lighttpd
Включите нижеприведенные модули с помощью "sudo lighty-включить-мод fastcgi; sudo lighty-включить-мод fastcgi-php; служба sudo lighttpd принудительно перезагрузить".
```
$ sudo lighty-enable-mod fastcgi
$ sudo lighty-enable-mod fastcgi-php
$ sudo service lighttpd force-reload
```
### #3: File Transfer Protocol *(FTP)*

#### Step 1: Installing & Configuring FTP

Установка FTP(FTP (File Transfer Protocol - протокол передачи файлов) - это популярный сетевой протокол, который используется для копирования файлов с одного компьютера на другой в локальной сети, либо в сети Интернет. FTP является одним из старейших прикладных протоколов, появившимся задолго до HTTP, и даже до TCP/IP, в 1971 году.)
    
```
$ sudo apt install vsftpd
```
Проверим
```
$ dpkg -l | grep vsftpd
```
Разрешить входящие соединения с использованием порта 21
```
$ sudo ufw allow 21
```
Настроим FTP
```
$ sudo vim /etc/vsftpd.conf
```
Чтобы включить любую форму команды записи FTP, раскомментируйте строку ниже:
```
31 #write_enable=YES
```
Чтобы установить корневую папку для пользователя, подключенного по FTP, в `/home/<username>/ftp`, добавьте нижеприведенные строки:
```
$ sudo mkdir /home/<username>/ftp
$ sudo mkdir /home/<username>/ftp/files
$ sudo chown nobody:nogroup /home/<username>/ftp
$ sudo chmod a-w /home/<username>/ftp
<~~~>
user_sub_token=$USER
local_root=/home/$USER/ftp
<~~~>
```
Чтобы запретить пользователю доступ к файлам или использование команд за пределами дерева каталогов, раскомментируйте строку ниже:
```
114 #chroot_local_user=YES
```
To whitelist FTP, add below lines:
```
$ sudo vi /etc/vsftpd.userlist
$ echo <username> | sudo tee -a /etc/vsftpd.userlist
<~~~>
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
<~~~>
```

#### Step 2: Connecting to Server via FTP
FTP в вашу виртуальную машину 
```
$ ftp <ip-address>
```
Terminate FTP session at any time via `CTRL + D`.

## Difference Between CentOS and Debian

CentOS vs Debian are two flavors of Linux operating systems. CentOS, as said above, is a Linux distribution. It is free and open-source. It is enterprise-class – industries can use meaning for server building; it is supported by a large community and is functionally supported by its upstream source, Red Hat Enterprise Linux. Debian is a Unix like computer operating system that is made up of open source components. It is built and supported by a group of individuals who are under the Debian project.

Debian uses Linux as its Kernel. Fedora, CentOS, Oracle Linux are all different distribution from Red Hat Linux and are variant of RedHat Linux. Ubuntu, Kali, etc., are variant of Debian. CentOS vs Debian both are used as internet servers or web servers like web, email, FTP, etc.

## Difference between APT and Aptitude

Besides the main difference being that Aptitude is a high level package manager while APT is a lower level package manager that can be used by other higher level package managers, the other main strengths that separate these two package managers are:

Aptitude is more feature-rich than apt-get and incorporates functionality from apt-get and its other variants, including apt-mark and apt-cache.
While apt-get handles all package installation, upgrading, system upgrading, package purging, dependency resolution, etc., Aptitude handles a lot more things than apt, including including apt-mark and apt-cache functionality, i.e. finding a package in the list of installed packages, marking a package to be installed automatically or manually, containing a package making it unavailable for upgrading, etc.

## What is SELinux ?

SELinux (Security-Enhanced Linux) is a security architecture for Linux® systems that allows administrators to better control access to the system. This architecture was originally designed by the NSA, the national security agency of the United States, as a series of fixes for the Linux kernel based on the LSM (Linux Security Modules) framework.

## What is AppArmor ?

AppArmor (Application Armor) is a security software for Linux systems made under GNU General Public License.

AppArmor allows the system admin to associate to each program a security profile which limits its' accesses to the operating system. It completes Unix's traditional way of Discretionary access control (DAC) by allowing the use of Mandatory access control (MAC).

### How to create a New User ?

Create new user via `sudo adduser <username>`.

	$>sudo adduser <username>

Verify whether user was successfully created via `getent passwd <username>`.

	$>getent passwd <username>

Verify newly-created user's password expiry information via `sudo chage -l <username>`.

	$ sudo chage -l <username>
	Last password change					: <last-password-change-date>
	Password expires					: <last-password-change-date + PASS_MAX_DAYS>
	Password inactive					: never
	Account expires						: never
	Minimum number of days between password change		: <PASS_MIN_DAYS>
	Maximum number of days between password change		: <PASS_MAX_DAYS>
	Number of days of warning before password expires	: <PASS_WARN_AGE>

At least for delete user via `sudo userdel <username>`.

	$>sudo userdel <username>

