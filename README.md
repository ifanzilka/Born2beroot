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


    
