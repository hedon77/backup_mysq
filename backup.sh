#!/bin/bash

DIR=/mnt/backup
LOG=/var/log/backup.log
DATA=`date +%Y-%m-%d_%H:%M:%S`
MAIL=backup@example.com

databases=`mysql -h localhost -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

echo $1

if [ "$1" = "monthly" ]; then

echo "$DATA Backup $1 ...."

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -h localhost --databases $db > $DIR/monthly/`date +%d-%m-%Y`.$db.sql
        gzip $DIR/monthly/`date +%d-%m-%Y`.$db.sql
        FILESIZE=$(stat -c%s "$DIR/monthly/`date +%d-%m-%Y`.$db.sql.gz")
    fi
done

find $DIR/monthly/* -mtime +365 -type f -exec rm {} \;
echo "$DATA Backup $1 size: $FILESIZE" >> $LOG
echo "Backup OK" | mail -s "$DATA Backup $1 size: $FILESIZE" $MAIL

elif [ "$1" = "weekly" ]; then

echo "$DATA Backup $1 ...."

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -h localhost --databases $db > $DIR/weekly/`date +%d-%m-%Y`.$db.sql
        gzip $DIR/weekly/`date +%d-%m-%Y`.$db.sql
        FILESIZE=$(stat -c%s "$DIR/weekly/`date +%d-%m-%Y`.$db.sql.gz")
    fi
done

find $DIR/weekly/* -mtime +28 -type f -exec rm {} \;
echo "$DATA Backup $1 size: $FILESIZE" >> $LOG
echo "Backup OK" | mail -s "$DATA Backup $1 size: $FILESIZE" $MAIL


elif [ "$1" = "daily" ]; then

echo "$DATA Backup $1 ...."

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -h localhost --databases $db > $DIR/daily/`date +%d-%m-%Y`.$db.sql
        gzip $DIR/daily/`date +%d-%m-%Y`.$db.sql
        FILESIZE=$(stat -c%s "$DIR/daily/`date +%d-%m-%Y`.$db.sql.gz")
    fi

done

find $DIR/daily/* -mtime +60 -type f -exec rm {} \;
echo "$DATA Backup $1 size: $FILESIZE" >> $LOG
echo "Backup OK" | mail -s "$DATA Backup $1 size: $FILESIZE" $MAIL

else

echo 'Empty ... :D'

fi
