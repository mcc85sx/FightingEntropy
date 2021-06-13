set x=/var/etc/acme-client/certs
set y=`ls $x | tail -n 1`
set cert=`openssl x509 -in $x/$y/fullchain.pem -noout -text`


