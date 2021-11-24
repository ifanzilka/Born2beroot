#! /bin/bash

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
