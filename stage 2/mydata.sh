#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
echo "<html><head><meta charset="utf-8"><title>Этап 2</title></head><body><p>Тестовый веб сервер для второго этапа!</p></body></html>" > /var/www/html/index.html
sudo service apache2 start