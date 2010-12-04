#!/bin/sh
rm ~/Documents/thepeoplesfeed/public/sitemap.xml
rm -rf ~/Documents/thepeoplesfeed/tmp/cache/*
wget --spider http://localhost:9000/sitemap.xml
wget --spider http://localhost:9000/contribute
wget --spider http://localhost:9000/feed/new
wget --spider http://localhost:9000/category/2291
wget --spider http://localhost:9000/feed/25
