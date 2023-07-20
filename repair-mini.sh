#!/bin/bash
locale-gen
rm -f /etc/portage/repos.conf/*
cd /var/db
find dev-perl -type d|grep /|sed "s/dev-perl/=dev-perl/g"|xargs emerge -v -j$(nproc)
