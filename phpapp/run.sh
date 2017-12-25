#!/bin/bash

# ++ permissions

chown -R www-data:www-data /var/www

# ++ run daemons

services nginx restart
