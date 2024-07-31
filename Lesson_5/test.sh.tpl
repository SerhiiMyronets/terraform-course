#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo bash -c 'cat > /var/www/html/index.html' <<EOF_HTML
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
  <h1>Hello, ${firstName} ${lastName} and %{ for x in names ~}${x} %{ endfor ~}.</h1>
  <h1>Welcome to server !</h1>
</body>
</html>
EOF_HTML