#!/bin/sh
for i in `ls /srv/users/`; do
  chown -R ${i}:domain_users /srv/users/${i};
done
