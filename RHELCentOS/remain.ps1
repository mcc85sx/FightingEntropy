
$RH = [RHELCentOS]::New()

sudo mysql -u root -p
CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER roundcubeuser@localhost IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;
flush privileges;
