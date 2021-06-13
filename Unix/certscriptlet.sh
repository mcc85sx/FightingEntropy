8
set w="#########"
set x=/var/etc/acme-client/certs
set y=`ls $x | tail -n 1`
echo $w
openssl x509 -in $x/$y/fullchain.pem -noout -text
echo $w
exit
exit
