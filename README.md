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

#### Для начала  также установим tmux

    apt install tmux
    
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
Switch to *root* and its environment via `su -`.
```
$ su -
Password:
#
```
Install *sudo* via `apt install sudo`.
```
# apt install sudo
```
Verify whether *sudo* was successfully installed via `dpkg -l | grep sudo`.
```
# dpkg -l | grep sudo
```


## Настройка SSH

 Все настройки тут https://www.aitishnik.ru/linux/ssh-debian/nastroyka-openssh.html

Открываем файл

    vim /etc/ssh/sshd_config
Раскоменчиваем 
        
        Port 4242
        PermitRootLogin no
Перезапустим ssh
         
         /etc/init.d/sshd restart
         
Теперь мы можем подключаться вот так
        
        ssh user42@127.0.0.1 -p 4242
## Теперь настроим Firewall чтобы был открыть только порт 4242
Скачаем для начала утилиту
        
        sudo apt install ufw
 Откроем порт 4242
        
        sudo ufw allow 4242/tcp
  Включим фаерволл

        sudo ufw enable
  Смотрим статус
        
        sudo ufw status
