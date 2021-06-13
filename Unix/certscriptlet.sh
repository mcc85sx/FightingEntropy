set pathx=/var/etc/acme-client/certs
set pathy=`ls $pathx | `
set pathz=$pathx/$pathy[2]/fullchain.pem

set certificate=`openssl x509 -in $pathz -noout -text`
