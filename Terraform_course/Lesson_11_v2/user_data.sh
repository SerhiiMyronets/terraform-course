#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<style>
  body {
    background-color: #A1B0FF;
    text-align: center;
  }
</style>
</head>
<body>
  <h1>Hello, Friend.</h1>
  <h1>Welcome to server 3.0!</h1>
  <h1>$myip<h1>
</body>
</html>
EOF

service httpd start
chkconfig httpd on