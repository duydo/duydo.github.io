---
title: "Google Desktop & Picasa for Linux"
date: 2007-06-29T12:57:42+07:00
lastmod: 2023-01-03T12:57:42+07:00
tags: ["engineering", "linux", "google", "picasa"]
---


I’m very glad to know these softwares are supported for Linux. I love Google products, they’re simple but powerful :).
Below is instructions for setting up these softwares on Fedora and Ubuntu (I only know these distros :D)


<!--more-->

### 1. For Ubutntu

Step 1: Type command below to sign key for Google’s Linux packages

```sh
wget -q -O – http://dl.google.com/linux/linux_signing_key.pub
sudo apt-key add linux_signing_key.pub
sudo apt-get update
```

Step 2: Add the following rule to /etc/apt/sources.list,

```sh
# Google software repository
deb http://dl.google.com/linux/deb/ stable non-free
```

Step 3: Type below command to refresh source list:

```sh
 sudo apt-get update
```

Step 4: Install Google Desktop and Picasa
```sh
sudo apt-get install google-desktop-linux
sudo apt-get install picasa
```

### 2. For Fedora Core

Run below commands as root

Step 1: Type command below to sign key for Google’s Linux packages

```sh
wget http://dl.google.com/linux/linux_signing_key.pub
rpm --import linux_signing_key.pub
```

Step 2: As root, add the following to a file called google.repo in `/etc/yum.repos.d/`:
```sh
 [google] name=Google – $basearchbaseurl=http://dl.google.com/linux/rpm/stable/$basearchenabled=1gpgcheck=1
```

Step 3: Install Google Desktop and Picasa
```sh
yum -y install google-desktop-linux
yum -y install picasa
```

For both of distros, invoke these program by typing command:

```sh
# Google Desktop
gdlinux
# Picasa
picasa
```
