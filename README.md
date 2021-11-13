# Born2beroot


#### Для начала установим tmux

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

## Настройка SSH

 Все настройки тут https://www.aitishnik.ru/linux/ssh-debian/nastroyka-openssh.html

Открываем файл

    vim /etc/ssh/sshd_config
Раскоменчиваем 
        
        Port 4242
        PermitRootLogin no        

    
