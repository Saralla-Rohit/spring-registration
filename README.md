# Spring Registration Application

A containerized Spring Boot MVC registration application using JSP, Spring Data JPA, MySQL, Docker, and Cloudflare Tunnel.

---

## 🌐 Live Application

**Live URL:** [spring-registration.rohitnet.dpdns.org](https://spring-registration.rohitnet.dpdns.org/?utm_source=chatgpt.com)

### Application Pages

* **Registration:** [Register Page](https://spring-registration.rohitnet.dpdns.org/register?utm_source=chatgpt.com)
* **Fetch Data:** [Fetch Data](https://spring-registration.rohitnet.dpdns.org/fetch?utm_source=chatgpt.com)

The application is publicly accessible through Cloudflare Tunnel.

---

## Architecture

```text
                         Internet
                            │
                            ▼
                    ┌─────────────────┐
                    │    Cloudflare   │
                    │      Tunnel     │
                    └────────┬────────┘
                             │
                             ▼
                    spring-registration
                    .rohitnet.dpdns.org
                             │
                             ▼
                    localhost:8081
                             │
                             ▼
              ┌──────────────────────────┐
              │   spring-registration    │
              │      Spring Boot         │
              │       Tomcat :8081       │
              └────────────┬─────────────┘
                           │
                    Docker network
                       spring-net
                           │
                           ▼
              ┌──────────────────────────┐
              │          mysql           │
              │       MySQL 9.7          │
              │        :3306             │
              └────────────┬─────────────┘
                           │
                           ▼
                    mysql-data volume
```

---

## Technologies

* Java 17
* Spring Boot 4.1.1
* Spring MVC
* Spring Data JPA
* Hibernate
* JSP
* Apache Tomcat 11
* MySQL 9.7
* Maven
* Docker
* Docker Network
* Docker Volume
* Cloudflare Tunnel
* Ubuntu Server

---

## Application Features

The application provides:

* Registration page
* Registration form submission
* Data persistence using MySQL
* Fetching registered data
* JSP-based views
* Exception handling
* Spring Data JPA repository integration
* Public HTTPS access through Cloudflare Tunnel

### Application URLs

```text
/register
```

Displays the registration page.

```text
/printDetail
```

Accepts registration form data using HTTP POST.

```text
/fetch
```

Fetches registration data from MySQL.

---

# Project Structure

```text
spring-registration/
│
├── Dockerfile
├── pom.xml
│
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       ├── SpringBootMvcFirstApp3Application.java
        │       │
        │       ├── controller/
        │       │   └── RegistrationController.java
        │       │
        │       ├── entity/
        │       │   └── RegistrationDetail.java
        │       │
        │       ├── repository/
        │       │   └── RegistrationRepository.java
        │       │
        │       └── service/
        │           └── RegistrationService.java
        │
        ├── resources/
        │   └── application.properties
        │
        └── webapp/
            └── WEB-INF/
                └── view/
                    ├── registration.jsp
                    ├── status.jsp
                    ├── print.jsp
                    └── errorPage.jsp
```

---

# Spring Configuration

`src/main/resources/application.properties`

```properties
spring.application.name=SpringBootMVCFirstApp-3
server.port=8081

spring.mvc.view.prefix=/WEB-INF/view/
spring.mvc.view.suffix=.jsp

spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=create
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

### Environment Variables

The application receives database configuration through environment variables:

```text
DB_URL
DB_USERNAME
DB_PASSWORD
```

Example:

```text
DB_URL=jdbc:mysql://mysql:3306/rohit
DB_USERNAME=root
DB_PASSWORD=<your-password>
```

The application does not use `localhost` for MySQL.

Inside Docker, the MySQL container is reachable using:

```text
mysql:3306
```

because both containers are connected to the `spring-net` Docker network.

---

# Controller

The main controller provides:

```text
/register
/printDetail
/fetch
```

The registration process is:

```text
Browser
   ↓
/register
   ↓
registration.jsp
   ↓
POST /printDetail
   ↓
RegistrationController
   ↓
RegistrationService
   ↓
RegistrationRepository
   ↓
MySQL
   ↓
status.jsp
```

---

# Database

The application uses:

```text
Database: rohit
User: root
Host: mysql
Port: 3306
```

The MySQL container is intentionally **not exposed to the host or Internet**.

The database is accessible only through the Docker network.

```text
spring-registration
        │
        │ spring-net
        ▼
      mysql:3306
```

---

# Docker

## Docker Network

Create the application network:

```bash
docker network create spring-net
```

Check:

```bash
docker network inspect spring-net
```

---

## MySQL Volume

Create persistent database storage:

```bash
docker volume create mysql-data
```

Check:

```bash
docker volume inspect mysql-data
```

The volume is mounted at:

```text
/var/lib/mysql
```

inside the MySQL container.

---

# MySQL Container

Create the MySQL container:

```bash
docker run -d \
  --name mysql \
  --restart unless-stopped \
  --network spring-net \
  -e MYSQL_ROOT_PASSWORD='YOUR_MYSQL_PASSWORD' \
  -e MYSQL_DATABASE=rohit \
  -v mysql-data:/var/lib/mysql \
  mysql:9.7
```

Important:

There is intentionally **no**:

```text
-p 3306:3306
```

This keeps MySQL private.

Check:

```bash
docker ps
```

Check MySQL logs:

```bash
docker logs mysql
```

---

# Dockerfile

```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/SpringBootMVCFirstApp-3-0.0.1-SNAPSHOT.war app.war

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.war"]
```

The Dockerfile uses a multi-stage build.

### Build Stage

```text
maven:3.9-eclipse-temurin-17
```

compiles the application and creates the WAR.

### Runtime Stage

```text
eclipse-temurin:17-jre
```

runs only the packaged application.

---

# Build Docker Image

From the project directory:

```bash
docker build -t spring-registration:1.0 .
```

Check:

```bash
docker images
```

Expected image:

```text
spring-registration:1.0
```

---

# Run Spring Application

```bash
docker run -d \
  --name spring-registration \
  --restart unless-stopped \
  --network spring-net \
  -p 8081:8081 \
  -e DB_URL="jdbc:mysql://mysql:3306/rohit" \
  -e DB_USERNAME="root" \
  -e DB_PASSWORD='YOUR_MYSQL_PASSWORD' \
  spring-registration:1.0
```

---

# Verify Containers

```bash
docker ps
```

Expected:

```text
mysql                 Up
spring-registration   Up
```

The application should expose:

```text
0.0.0.0:8081 -> 8081
```

---

# Test Locally

Test the registration page:

```bash
curl -I http://localhost:8081/register
```

Or open:

```text
http://SERVER-IP:8081/register
```

---

# Check Spring Logs

```bash
docker logs spring-registration
```

Follow logs:

```bash
docker logs -f spring-registration
```

A successful startup contains:

```text
Tomcat started on port 8081
Started SpringBootMvcFirstApp3Application
```

Successful database connectivity contains:

```text
HikariPool-1 - Added connection
```

and:

```text
Database JDBC URL [jdbc:mysql://mysql:3306/rohit]
```

---

# Check Environment Variables

```bash
docker exec spring-registration env | grep '^DB_'
```

Expected:

```text
DB_URL=jdbc:mysql://mysql:3306/rohit
DB_USERNAME=root
DB_PASSWORD=...
```

Do not commit the actual database password to Git.

---

# Check Restart Policies

```bash
docker inspect -f \
'{{.Name}} -> restart={{.HostConfig.RestartPolicy.Name}} status={{.State.Status}}' \
mysql spring-registration
```

Expected:

```text
/mysql -> restart=unless-stopped status=running
/spring-registration -> restart=unless-stopped status=running
```

`unless-stopped` is important because the containers should automatically start after a server reboot.

---

# Restart Containers

Restart MySQL:

```bash
docker restart mysql
```

Restart Spring:

```bash
docker restart spring-registration
```

Restart both:

```bash
docker restart mysql spring-registration
```

Check:

```bash
docker ps
```

---

# Server Reboot Behavior

After reboot:

```bash
docker ps
```

The following containers should automatically start:

```text
mysql
spring-registration
calci
tailscale
```

The dependency chain is:

```text
MySQL
  ↓
Spring Registration
```

Therefore MySQL must be available for Spring to successfully initialize its datasource.

---

# Cloudflare Tunnel

The application is published through Cloudflare Tunnel without exposing port 8081 directly to the public Internet.

### Public URL

```text
https://spring-registration.rohitnet.dpdns.org/
```

### Cloudflare Flow

```text
Internet
    ↓
Cloudflare
    ↓
Cloudflare Tunnel
    ↓
Ubuntu Server
    ↓
localhost:8081
    ↓
spring-registration
```

Cloudflare hostname:

```text
spring-registration.rohitnet.dpdns.org
```

Cloudflare Tunnel forwards the hostname to:

```text
http://localhost:8081
```

The application itself does not need to know anything about Cloudflare.

---

# Production Flow

```text
User
 │
 ▼
https://spring-registration.rohitnet.dpdns.org/
 │
 ▼
Cloudflare
 │
 ▼
Cloudflare Tunnel
 │
 ▼
Ubuntu Server
 │
 ▼
localhost:8081
 │
 ▼
Spring Boot Container
 │
 ▼
MySQL Container
```

---

# Why MySQL Is Not Public

Do **not** expose:

```text
3306
```

to the Internet.

The correct architecture is:

```text
Internet
   ↓
Cloudflare
   ↓
Spring :8081
   ↓
MySQL :3306
```

not:

```text
Internet
   ↓
MySQL :3306
```

MySQL remains inside the Docker network.

---

# Useful Docker Commands

### List all containers

```bash
docker ps -a
```

### Running containers

```bash
docker ps
```

### View Spring logs

```bash
docker logs spring-registration
```

### View MySQL logs

```bash
docker logs mysql
```

### Follow Spring logs

```bash
docker logs -f spring-registration
```

### Restart Spring

```bash
docker restart spring-registration
```

### Restart MySQL

```bash
docker restart mysql
```

### Inspect Spring

```bash
docker inspect spring-registration
```

### Inspect MySQL

```bash
docker inspect mysql
```

### Check network

```bash
docker network inspect spring-net
```

### Check volume

```bash
docker volume inspect mysql-data
```

---

# Troubleshooting

## Spring Container Keeps Restarting

Check:

```bash
docker logs --tail 100 spring-registration
```

If the logs show:

```text
Failed to configure a DataSource
```

check the database environment variables:

```bash
docker exec spring-registration env | grep '^DB_'
```

Check MySQL:

```bash
docker ps
```

MySQL must be running.

---

## Spring Cannot Connect to MySQL

Check that both containers are on the same network:

```bash
docker network inspect spring-net
```

Both should appear:

```text
mysql
spring-registration
```

Check the JDBC URL:

```text
jdbc:mysql://mysql:3306/rohit
```

Do not use:

```text
jdbc:mysql://localhost:3306/rohit
```

inside the Spring container.

---

## Cloudflare Returns 502

First test the application locally:

```bash
curl -I http://localhost:8081/register
```

If this fails:

```text
Cloudflare is not the problem.
```

Check:

```bash
docker ps
docker logs spring-registration
```

If local access works but Cloudflare returns 502, check the Cloudflare Tunnel configuration.

The origin should point to:

```text
http://localhost:8081
```

---

## MySQL Is Stopped After Reboot

Check:

```bash
docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' mysql
```

It should return:

```text
unless-stopped
```

If not:

```bash
docker update --restart unless-stopped mysql
```

---

## Spring Is Stopped After Reboot

Check:

```bash
docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' spring-registration
```

Fix:

```bash
docker update --restart unless-stopped spring-registration
```

---

# Current Container Architecture

```text
┌──────────────────────────────────────────────────┐
│                 Ubuntu Server                    │
│                                                  │
│  ┌────────────────────────────────────────────┐  │
│  │              Docker                       │  │
│  │                                            │  │
│  │  ┌──────────────────┐                     │  │
│  │  │    spring-net    │                     │  │
│  │  │                  │                     │  │
│  │  │ ┌──────────────┐ │   ┌──────────────┐ │  │
│  │  │ │    Spring    │ │   │    MySQL     │ │  │
│  │  │ │ registration │◄├───►│    :3306     │ │  │
│  │  │ │    :8081     │ │   └──────┬───────┘ │  │
│  │  │ └───────┬──────┘ │          │         │  │
│  │  └──────────┼────────┘          │         │  │
│  │             │                   │         │  │
│  └─────────────┼───────────────────┼─────────┘  │
│                │                   │            │
│          Host :8081          mysql-data         │
│                                                  │
│                │                                 │
│         cloudflared                              │
└────────────────┼─────────────────────────────────┘
                 │
                 ▼
            Cloudflare
                 │
                 ▼
     spring-registration.rohitnet.dpdns.org
```

---

# Deployment Summary

The application is deployed using the following components:

```text
Spring Boot
    ↓
WAR
    ↓
Docker Image
    ↓
Spring Container
    ↓
Docker Network
    ↓
MySQL Container
    ↓
Docker Volume
```

Public access:

```text
Internet
    ↓
Cloudflare Tunnel
    ↓
Spring Container
```

Database access:

```text
Spring Container
    ↓
spring-net
    ↓
MySQL Container
    ↓
mysql-data
```

---

# Important Security Notes

Never commit passwords to Git.

Use:

```text
YOUR_MYSQL_PASSWORD
```

in documentation instead of the real password.

MySQL should remain private and should not be published with:

```bash
-p 3306:3306
```

Only the application HTTP port needs to be reachable by the reverse proxy/tunnel.

---

# Quick Deployment

For a fresh deployment:

```bash
docker network create spring-net
docker volume create mysql-data
```

Start MySQL:

```bash
docker run -d \
  --name mysql \
  --restart unless-stopped \
  --network spring-net \
  -e MYSQL_ROOT_PASSWORD='YOUR_MYSQL_PASSWORD' \
  -e MYSQL_DATABASE=rohit \
  -v mysql-data:/var/lib/mysql \
  mysql:9.7
```

Build application:

```bash
docker build -t spring-registration:1.0 .
```

Start application:

```bash
docker run -d \
  --name spring-registration \
  --restart unless-stopped \
  --network spring-net \
  -p 8081:8081 \
  -e DB_URL="jdbc:mysql://mysql:3306/rohit" \
  -e DB_USERNAME="root" \
  -e DB_PASSWORD='YOUR_MYSQL_PASSWORD' \
  spring-registration:1.0
```

Verify:

```bash
docker ps
```

Test:

```bash
curl -I http://localhost:8081/register
```

Then verify the public application:

```text
https://spring-registration.rohitnet.dpdns.org/
```

---

# Final Architecture

```text
                         PUBLIC INTERNET
                               │
                               ▼
                     ┌───────────────────┐
                     │    Cloudflare     │
                     │      Tunnel       │
                     └─────────┬─────────┘
                               │
                               ▼
            https://spring-registration.
                 rohitnet.dpdns.org/
                               │
                               ▼
                     ┌───────────────────┐
                     │ Ubuntu Server     │
                     │                   │
                     │ localhost:8081   │
                     └─────────┬─────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ spring-registration │
                    │    Spring Boot      │
                    │      Tomcat         │
                    └──────────┬──────────┘
                               │
                         spring-net
                               │
                               ▼
                    ┌─────────────────────┐
                    │        MySQL        │
                    │       :3306         │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    mysql-data       │
                    │   Docker Volume     │
                    └─────────────────────┘
```

---

## Live Deployment

The application is currently deployed and publicly accessible through:

**https://spring-registration.rohitnet.dpdns.org/**

The production stack consists of:

```text
Cloudflare Tunnel
        ↓
Ubuntu Server
        ↓
Docker
        ↓
Spring Boot + Tomcat
        ↓
Docker Network: spring-net
        ↓
MySQL 9.7
        ↓
Docker Volume: mysql-data
```

The Spring application runs on port `8081`, while MySQL remains private on port `3306` inside the Docker network.
