#! /bin/bash

#apt install sudo
## add user 
#adduser bmarilli sudo
#su bmarilli
#sudo apt update
#sudo apt install vim
#sudo apt install tmux
#sudo apt install openssh-server
#sudo vim /etc/ssh/sshd_config
#ssh bmarilli@127.0.0.1 -p 4242
sudo apt install ufw -y
sudo ufw enable -y
sudo ufw allow 4242
sudo ufw status
## sudo conf
sudo touch  /etc/sudoers.d/conf_sudo
sudo sh -c "echo 'Defaults        passwd_tries=3' >> /etc/sudoers.d/conf_sudo"
sudo sh -c "echo 'Defaults        badpass_message=\"lol bad password\"' >> /etc/sudoers.d/conf_sudo"
sudo mkdir /var/log/sudo
sudo touch /var/log/sudo/logs_sudo
sudo sh -c "echo 'Defaults        logfile=\"/var/log/sudo/logs_sudo\"' >> /etc/sudoers.d/conf_sudo"
sudo sh -c "echo 'Defaults        log_input,log_output' >> /etc/sudoers.d/conf_sudo"
sudo sh -c "echo 'Defaults        iolog_dir=\"/var/log/sudo\"' >> /etc/sudoers.d/conf_sudo"
sudo sh -c "echo 'Defaults        requiretty' >> /etc/sudoers.d/conf_sudo"
sudo sh -c "echo 'Defaults        secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin\"' >> /etc/sudoers.d/conf_sudo"

#change files from password politicks
sudo sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS   30/' /etc/login.defs
sudo sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS   2/' /etc/login.defs
sudo sed -i 's/PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs
sudo apt install libpam-pwquality -y
sudo sed -i 's/.*pam_pwquality.so.*/password        requisite                       pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root/' /etc/pam.d/common-password
sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")'fanzil) fanzil
sudo chage -l fanzil
sudo addgroup user42
sudo adduser fanzil user42
sudo adduser bmarilli user42
