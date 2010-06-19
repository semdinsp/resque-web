#!/bin/bash
sudo chown -R ubuntu .
git pull git@github.com:semdinsp/resque-web.git
sudo chown -R www-data:www-data .
