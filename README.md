# backup_mysq

mkdir daily weekly monthly

add crontab 

0 22 * * * /root/scripts/backup.sh daily
0 22 * * 6 /root/scripts/backup.sh weekly
0 22 1 * * /root/scripts/backup.sh monthly

