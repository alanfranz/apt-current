FROM ubuntu:bionic
MAINTAINER Alan Franzoni <username@franzoni.eu>
COPY 80-acquire-retries /etc/apt/apt.conf.d/
RUN apt-get update && apt-get -y install apt-transport-https curl ruby rubygems-integration ruby-dev build-essential rsync && apt-get clean && rm -f /var/lib/apt/lists/* ; rm -f /var/lib/apt/lists/partial/*
RUN gem install fpm -v 1.9.3
