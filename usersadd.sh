sudo adduser fanzil
sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")'fanzil) fanzil
sudo chage -l fanzil
sudo addgroup user42
sudo adduser fanzil user42
sudo adduser bmarilli user42
