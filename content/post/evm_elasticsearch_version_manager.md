+++
date = "2017-05-20T17:50:35+07:00"
draft = false
image = ""
tags = [ "shell", "bash", "elasticsearch", "version-manager", "engineering"]
title = "EVM - Elasticsearch Version Manager"
comment = true
toc = false
+++

As an Elasticsearch consultant, I often work with different versions of Elasticsearch. To make my developer life easier, I created [**evm**](https://github.com/duydo/evm). It allows me to install, remove, test multiple versions easily.

<!--more-->

### Installation

Just download the `evm` script and make it executable.

```sh
sudo curl -o /usr/local/bin/evm https://raw.githubusercontent.com/duydo/evm/master/evm
sudo chmod +x /usr/local/bin/evm
```

### Usage
```sh
evm -h                                     Print help information
evm -V                                     Print version information
evm list                                   List all installed ES versions
evm version                                Print the current activated ES version
evm install <version>                      Install a specific ES version
evm use <version>                          Use a specific ES version
evm remove <version>                       Remove a specific ES version if available
evm which [<version>]                      Print path to installed ES version
evm plugin list                            List all installed ES plugins
evm plugin <install|remove> <plugin>       Install or remove an ES plugin
evm start [-c </path/to/config/dir>]       Start ES in the background with a specific config directory (optional)
evm stop                                   Stop ES if it is running
evm status                                 Check if ES is running
```

### Example
```sh
evm install 5.3.1                          Install ES 5.3.1
evm use 5.3.1                              Use ES 5.3.1
evm start                                  Start ES node with the default config directory
evm start -c /etc/elasticsearch            Start ES node with /etc/elasticsearch config directory
evm status                                 Print ES running status
evm stop                                   Stop ES if it is running
evm plugin install x-pack                  Install the x-pack plugin
evm plugin remove x-pack                   Remove the x-pack plugin
```
