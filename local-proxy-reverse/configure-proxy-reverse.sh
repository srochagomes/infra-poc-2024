#!/bin/bash
cp config-nginx.txt /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl restart nginx