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
