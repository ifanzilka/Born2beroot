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
   
