---
title: "Spring 3 + JPA 2.0 + Hibernate 3.5.1-Final + Wicket 1.4.9 + Maven 2"
date: 2010-01-25T12:09:04+07:00
lastmod: 2023-01-03T12:09:04+07:00
draft: false
tags: ["engineering", "java", "spring", "jpa", "hibernate", "wicket", "maven"]
---

This is just a quick note for someone wants to use Spring 3, Jpa 2, Hibernate 3 and Wicket within Maven 2 project.

<!--more-->


You can download an example project [here](https://www.dropbox.com/s/jf2yys51l4k8r1x/wicket-spring-jpa-hibernate.zip?dl=0) and remember that only Spring version from 3.0.1 supports JPA 2 fully.

### I. Add properties and dependencies into your POM.XML file

#### 1. Add properties
```xml
<properties>
       ...
       <wicket.version>1.4.9</wicket.version>
       <spring.version>3.0.2.RELEASE</spring.version>
       <hibernate.version>3.5.1-Final</hibernate.version>
</properties>
```
#### 2. Add Wicket dependencies
```xml
<!--  WICKET DEPENDENCIES -->
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket</artifactId>
    <version>${wicket.version}</version>
</dependency>
<dependency>
   <groupId>org.apache.wicket</groupId>
   <artifactId>wicket-extensions</artifactId>
   <version>${wicket.version}</version>
</dependency>

<!--  WICKET-SPRING DEPENDENCIES -->
 <dependency>
 <groupId>org.apache.wicket</groupId>
 <artifactId>wicket-spring</artifactId>
 <version>${wicket.version}</version>
 </dependency>
```
#### 3. Add Spring 3 dependencies
```xml
<!--  SPRING DEPENDENCIES -->
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-core</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-web</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-beans</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-aop</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-context</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-context-support</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-tx</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-jdbc</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-orm</artifactId>
 <version>${spring.version}</version>
 </dependency>
 <dependency>
 <groupId>org.springframework</groupId>
 <artifactId>spring-test</artifactId>
 <version>${spring.version}</version>
 <scope>test</scope>
 </dependency>
```
#### 4. Add JPA 2.o /Hibernate 3 dependencies
```
<!-- HIBERNATE 3.5.1 JPA -->
 <dependency>
 <groupId>org.hibernate.java-persistence</groupId>
 <artifactId>jpa-api</artifactId>
 <version>2.0-cr-1</version>
 </dependency>
 <dependency>
 <groupId>org.hibernate</groupId>
 <artifactId>hibernate-entitymanager</artifactId>
 <version>${hibernate.version}</version>
 </dependency>
<!-- C3p0 for Datasource -->
 <dependency>
 <groupId>c3p0</groupId>
 <artifactId>c3p0</artifactId>
 <version>0.9.0.4</version>
 </dependency>

<!-- H2 DEPENDENCIES for testing -->
 <dependency>
 <groupId>com.h2database</groupId>
 <artifactId>h2</artifactId>
 <version>1.2.125</version>
 </dependency>
```

### II. Create applicationContext.xml for Spring 3
#### 1. Create application.properties for datasource and jpa configuration:
```
# connection pool config (c3p0 ComboPooledDataSource)
# all time values are in seconds
c3p0.minPoolSize=2
c3p0.maxPoolSize=20
c3p0.maxConnectionAge=21600
c3p0.maxIdleTime=3600
c3p0.idleConnectionTestPeriod=300

# Development config with H2 database
jdbc.driver=org.h2.Driver
jdbc.url=jdbc:h2:~/your_database
jdbc.username=sa
jdbc.password=

jpa.databasePlatform=org.hibernate.dialect.HSQLDialect
jpa.generateDdl=true
jpa.showSql=true
```

#### 2. An example applicatonContext.xml:
```xml
 <?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
 xmlns:tx="http://www.springframework.org/schema/tx" xmlns:p="http://www.springframework.org/schema/p"
 xmlns:aop="http://www.springframework.org/schema/aop"
 xsi:schemaLocation="http://www.springframework.org/schema/beans  http://www.springframework.org/schema/beans/spring-beans-3.0.xsd  http://www.springframework.org/schema/context  http://www.springframework.org/schema/context/spring-context-3.0.xsd  http://www.springframework.org/schema/tx  http://www.springframework.org/schema/tx/spring-tx-3.0.xsd  http://www.springframework.org/schema/aop  http://www.springframework.org/schema/aop/spring-aop-3.0.xsd">

 <context:annotation-config />
 <context:component-scan base-package="com.duydo.model" />
 <tx:annotation-driven transaction-manager="transactionManager" />

 <context:property-placeholder location="classpath:application.properties"/>

 <bean id="dataSource">
 <property name="driverClass">
 <value>${jdbc.driver}</value>
 </property>
 <property name="jdbcUrl">
 <value>${jdbc.url}</value>
 </property>
 <property name="user">
 <value>${jdbc.username}</value>
 </property>
 <property name="password">
 <value>${jdbc.password}</value>
 </property>
 <property name="minPoolSize">
 <value>${c3p0.minPoolSize}</value>
 </property>
 <property name="maxPoolSize">
 <value>${c3p0.maxPoolSize}</value>
 </property>
 <property name="checkoutTimeout">
 <!-- Give up waiting for a connection after this many milliseconds -->
 <value>20000</value>
 </property>
 <property name="maxIdleTime">
 <value>${c3p0.maxIdleTime}</value>
 </property>
 <property name="idleConnectionTestPeriod">
 <value>${c3p0.idleConnectionTestPeriod}</value>
 </property>
 </bean>

 <bean
 class="org.springframework.orm.jpa.support.PersistenceAnnotationBeanPostProcessor" />

 <bean id="entityManagerFactory"
 class="org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean">
 <property name="persistenceUnitName" value="wsjhPU" />
 <property name="dataSource" ref="dataSource" />
 <property name="jpaVendorAdapter">
 <bean>
 <property name="databasePlatform" value="${jpa.databasePlatform}" />
 <property name="showSql" value="${jpa.showSql}" />
 <property name="generateDdl" value="${jpa.generateDdl}" />
 </bean>
 </property>
 </bean>
 <bean id="transactionManager">
 <property name="entityManagerFactory" ref="entityManagerFactory" />
 <property name="dataSource" ref="dataSource" />
 </bean>

 <bean id="wicketApplication" class="com.duydo.WicketApplication"/>

</beans>
```

### III. Modify your PERSISTENCE.XML as following
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="2.0"
 xmlns="http://java.sun.com/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">
 <persistence-unit name="wsjhPU" transaction-type="RESOURCE_LOCAL">
 <provider>org.hibernate.ejb.HibernatePersistence</provider>
 </persistence-unit>
</persistence>
```

### IV. Modify your WEB.XML as following
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<web-app xmlns="http://java.sun.com/xml/ns/j2ee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
 version="2.4">

 <display-name>wicket-spring-jpa-hibernate</display-name>

 <context-param>
 <param-name>contextConfigLocation</param-name>
 <param-value>classpath:applicationContext.xml</param-value>
 </context-param>

 <filter>
 <filter-name>open.entitymanager.in.view</filter-name>
 <filter-class>org.springframework.orm.jpa.support.OpenEntityManagerInViewFilter</filter-class>
 </filter>

 <filter>
 <filter-name>wicket.wicket-spring-jpa-hibernate</filter-name>
 <filter-class>org.apache.wicket.protocol.http.WicketFilter</filter-class>
 <init-param>
 <param-name>applicationFactoryClassName</param-name>
 <param-value>org.apache.wicket.spring.SpringWebApplicationFactory</param-value>
 </init-param>
 <init-param>
 <param-name>configuration</param-name>
 <param-value>development</param-value>
 </init-param>
 </filter>

 <filter-mapping>
 <filter-name>open.entitymanager.in.view</filter-name>
 <url-pattern>/*</url-pattern>
 </filter-mapping>

 <filter-mapping>
 <filter-name>wicket.wicket-spring-jpa-hibernate</filter-name>
 <url-pattern>/*</url-pattern>
 </filter-mapping>

 <listener>
 <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
 </listener>
</web-app>
```
