CN="rabbitmq.local"
openssl genrsa 4096 > ca-key.pem
openssl req -new -x509 -nodes -days 365000 -key ca-key.pem -out ca-cert.pem -subj "/C=BR/ST=MG/L=Belo Horizonte/O=rabbitmq/CN=${CN}"
openssl req -newkey rsa:4096 -days 365000 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=BR/ST=MG/L=Belo Horizonte/O=rabbitmq/CN=${CN}"
openssl x509 -req -in server-req.pem -days 365000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
echo "127.0.0.1 ${CN}" >> /etc/hosts