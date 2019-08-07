+++
title = "How to build Elasticsearch Vietnamese Analysis Plugin"
date = "2017-04-21"
tags = ["elasticsearch","analysis", "vietnamese"]
comment = true
+++

Recently, I've received many requests to build the Vietnamese Analysis plugin when a new version of Elasticsearch is released but sometimes I'm not available to do it immediately. In case of urgent, you can build the plugin yourself with following steps.

<!--more-->

## Step 1: Install Java, Maven & Git
The plugin is written in Java and built with Maven, so you have to install them first. Here is the instructions for installing  [Java](https://www.java.com/en/download/help/download_options.xml), [Maven](https://maven.apache.org/install.html) and [Git](https://www.atlassian.com/git/tutorials/install-git).

If you are using Mac, just use these commands:
```sh
brew cask install java
brew install maven
brew install git
```
## Step 2: Build the VnTokenizer
The plugin is based on the VNTokenizer library, you have to build it before building the plugin
```sh
git clone https://github.com/duydo/vn-nlp-libraries.git
cd vn-nlp-libraries/nlp-parent
mvn install
```
## Step 3: Build the plugin
Clone the plugin's source code:
```sh
git clone https://github.com/duydo/elasticsearch-analysis-vietnamese.git
```

Edit the `elasticsearch-analysis-vietnamese/pom.xml` to change the version of Elasticsearch you want to build the plugin with:
```xml
<properties>
  ...
    <project.build.java.version>1.8</project.build.java.version>
    <elasticsearch.version>5.2.1</elasticsearch.version>
    <lucene.version>6.4.1</lucene.version>
    ...
</properties>
```
Build the plugin:
```sh
cd elasticsearch-analysis-vietnamese
mvn package
```

## Step 4: Install the plugin
```sh
mvn clean package
bin/elasticsearch-plugin install file:target/releases/elasticsearch-analysis-vietnamese-5.2.1.zip
```
