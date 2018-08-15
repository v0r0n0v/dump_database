#!/usr/local/bin/bash

#catalog
DUMP_DIR=/home/core/dump
SITES_DIR=/var/www

#autorization
USERNAME=root
NOW=$(date +%Y%m%d)
passwordDB="13f43s55z35"

#clear folder > 10
find $DUMP_DIR -type d \( -name "*-1[^5]" -o -name "*-[023]?" \) -ctime +30 -exec rm -R {} \; 2>&1
find $DUMP_DIR -type d -name "*-*" -ctime +10 -exec rm -R {} \; 2>&1

#create folder
mkdir $DUMP_DIR/$NOW && mkdir $DUMP_DIR/$NOW/bases && mkdir $DUMP_DIR/$NOW/sites

#go folder
cd $DUMP_DIR/$NOW/bases

#dump databases
echo "Dumping databases..";

#mysqldump -u$USERNAME -p --all-databases -v > databases.sql

for dbname in `echo show databases | mysql -u$USERNAME -p$passwordDB | grep -v Database`; do
    case $dbname in
        information_schema)
            continue ;;
        mysql)
            continue ;;
        performance_schema)
            continue ;;
        test)
            continue ;;
        *) mysqldump --databases --skip-comments -u$USERNAME -p$passwordDB $dbname | gzip > $DUMP_DIR/$NOW/bases/$dbname.sql.gz ;;
    esac
done;

#go folder
cd $DUMP_DIR/$NOW/sites

echo "Creating copies for every site...";

for file in `ls -1 $SITES_DIR`; do
	echo "Creating backup for $file...";
	if [ ! -f $DUMP_DIR/$NOW/sites/$file.tar.gz ]; then
		tar czvf $DUMP_DIR/$NOW/sites/$file.tar.gz -C $SITES_DIR $file
		fi
done;


# &> /dev/null
