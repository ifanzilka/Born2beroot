#! /bin/bash

#change files from password politicks
sudo sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS   30/' /etc/login.defs
sudo sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS   2/' /etc/login.defs
sudo sed -i 's/PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs

sudo apt install libpam-pwquality -y
sudo sed -i 's/.*pam_pwquality.so.*/password        requisite                       pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root/' /etc/pam.d/common-password
