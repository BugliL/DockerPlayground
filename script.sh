docker exec mysql -u root -e "cretate database testfunzionamento;"
docker exec mysql -u root -e "cretate database pmremote;"
docker exec test_lamp mysql -u root testfunzionamento < testfunzionamento.sql 
docker exec test_lamp mysql -u root pmremote < pmremote.sql 
