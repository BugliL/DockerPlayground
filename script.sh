docker exec -w /var/www/html -d test_lamp mysql -u root -e "create database testfunzionamento;"
docker exec -w /var/www/html -d test_lamp mysql -u root -e "create database pmremote;"
docker exec -w /var/www/html -d test_lamp mysql -u root testfunzionamento < testfunzionamento.sql 
docker exec -w /var/www/html -d test_lamp mysql -u root pmremote < pmremote.sql 
