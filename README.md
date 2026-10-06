# Spring Registration Application

A Spring Boot MVC registration application using JSP, Spring Data JPA, Hibernate, and MySQL. The application is containerized with Docker and publicly accessible through Cloudflare Tunnel.

## 🌐 Live Application

**Public URL:**

https://spring-registration.rohitnet.dpdns.org/

### Application Pages

* Registration: https://spring-registration.rohitnet.dpdns.org/register
* Fetch registered data: https://spring-registration.rohitnet.dpdns.org/fetch

---

# 🏗️ Architecture

```text
                         INTERNET
                            │
                            ▼
                    ┌─────────────────┐
                    │    Cloudflare   │
                    │     Tunnel      │
                    └────────┬────────┘
                             │
                             ▼
                  spring-registration
                  .rohitnet.dpdns.org
                             │
                             ▼
                    cloudflared daemon
                             │
                             ▼
                     localhost:8081
                             │
                             ▼
              ┌──────────────────────────┐
              │ Spring Registration      │
              │ Docker Container         │
              │ Port 8081                │
              └────────────┬─────────────┘
                           │
                           │ spring-net
                           ▼
              ┌──────────────────────────┐
              │ MySQL 9.7 Docker         │
              │ Container                │
              │ mysql:3306               │
              └────────────┬─────────────┘
                           │
                           ▼
                    Database: rohit
                           │
                    ┌──────┴─────────┐
                    │                │
             registration    registration_seq
```

---

# 🛠️ Technologies

* Java 17
* Spring Boot 4.1.1
* Spring MVC
* Spring Data JPA
* Hibernate
* JSP
* JSTL
* Apache Tomcat 11
* MySQL 9.7
* Maven
* Docker
* Docker Network
* Docker Volume
* Cloudflare Tunnel
* Ubuntu Server 24.04.x

---

# 📁 Project Structure

```text
spring-registration/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       ├── SpringBootMvcFirstApp3Application.java
│   │   │       │
│   │   │       ├── controller/
│   │   │       │   └── RegistrationController.java
│   │   │       │
│   │   │       ├── entity/
│   │   │       │   └── RegistrationDetail.java
│   │   │       │
│   │   │       └── service/
│   │   │           └── RegistrationService.java
│   │   │
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── view/
│   │               ├── registration.jsp
│   │               ├── status.jsp
│   │               ├── print.jsp
│   │               └── errorPage.jsp
│   │
│   └── test/
│
├── pom.xml
├── Dockerfile
└── README.md
```

---

# ⚙️ Spring Boot Configuration

`application.properties`:

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

The database credentials are supplied through Docker environment variables rather than being hard-coded in the application.

---

# 🗄️ Database Configuration

Spring connects to MySQL using:

```text
jdbc:mysql://mysql:3306/rohit
```

Important:

`mysql` is the Docker container name and is resolvable through the Docker network.

Inside Docker:

```text
Spring Container
      │
      ▼
mysql:3306
      │
      ▼
MySQL Container
```

---

# 🐳 Docker Network

The application and MySQL containers use a dedicated Docker network:

```bash
docker network create spring-net
```

Check it with:

```bash
docker network inspect spring-net
```

The network allows the Spring container to communicate with MySQL using:

```text
mysql:3306
```

---

# 💾 MySQL Persistent Storage

A Docker volume is used to persist the database:

```bash
docker volume create mysql-data
```

The volume is mounted at:

```text
mysql-data:/var/lib/mysql
```

This means removing/recreating the MySQL container does **not** remove the database data as long as the `mysql-data` volume is retained.

---

# 🐬 MySQL Docker Container

Current MySQL container:

```text
Container: mysql
Image: mysql:9.7
Internal Port: 3306
Host Port: 3307
Database: rohit
Network: spring-net
Volume: mysql-data
Restart Policy: unless-stopped
```

Create it with:

```bash
docker run -d \
  --name mysql \
  --restart unless-stopped \
  --network spring-net \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD='YOUR_MYSQL_PASSWORD' \
  -e MYSQL_DATABASE=rohit \
  -v mysql-data:/var/lib/mysql \
  mysql:9.7
```

### Why host port 3307?

The Ubuntu server already has another MySQL installation using port `3306`.

Therefore:

```text
Host MySQL 8.0
localhost:3306
        │
        └── Existing host MySQL


Docker MySQL 9.7
localhost:3307
        │
        └── Docker container port 3306
```

The Spring application does **not** use port 3307.

It continues to use:

```text
mysql:3306
```

because communication between the Docker containers happens through `spring-net`.

---

# 🖥️ Two MySQL Instances

This server currently has two separate MySQL installations.

## Host MySQL

Version:

```text
MySQL 8.0
```

Access:

```bash
sudo mysql -u root -p
```

Host MySQL:

```text
localhost:3306
```

Its `rohit` database currently contains:

```text
customers
employees
orders
```

---

## Docker MySQL

Version:

```text
MySQL 9.7
```

Access from the host:

```bash
mysql -h 127.0.0.1 -P 3307 -u root -p
```

Its `rohit` database contains:

```text
registration
registration_seq
```

This is the database used by the Spring application.

---

# 🔌 Spring → MySQL Connection

The Spring container has:

```text
DB_URL=jdbc:mysql://mysql:3306/rohit
DB_USERNAME=root
DB_PASSWORD=********
```

Check the configuration:

```bash
docker exec spring-registration env | grep '^DB_'
```

Expected:

```text
DB_URL=jdbc:mysql://mysql:3306/rohit
DB_USERNAME=root
DB_PASSWORD=********
```

---

# 🚀 Spring Dockerfile

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

The application is packaged as a WAR and executed using the Java runtime.

---

# 🏗️ Build the Application Image

From the project directory:

```bash
docker build -t spring-registration:1.0 .
```

Check the image:

```bash
docker images
```

---

# ▶️ Run Spring Application

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

# 🔎 Check Running Containers

```bash
docker ps
```

Expected architecture:

```text
mysql
spring-registration
calci
tailscale
```

Check restart policies:

```bash
docker inspect -f '{{.Name}} -> restart={{.HostConfig.RestartPolicy.Name}} status={{.State.Status}}' \
mysql spring-registration calci
```

Expected:

```text
/mysql -> restart=unless-stopped status=running
/spring-registration -> restart=unless-stopped status=running
/calci -> restart=unless-stopped status=running
```

---

# 📜 Spring Logs

View application logs:

```bash
docker logs spring-registration
```

Follow logs:

```bash
docker logs -f spring-registration
```

A successful startup contains:

```text
Tomcat initialized with port 8081
HikariPool - Added connection
Database JDBC URL [jdbc:mysql://mysql:3306/rohit]
Tomcat started on port 8081
Started SpringBootMVCFirstApp3Application
```

---

# 🗄️ Verify Database

Connect directly to the Docker MySQL container:

```bash
docker exec -it mysql mysql -uroot -p
```

Then:

```sql
USE rohit;
SHOW TABLES;
```

Expected:

```text
+------------------+
| Tables_in_rohit  |
+------------------+
| registration     |
| registration_seq |
+------------------+
```

---

# 📊 Check Registration Data

From the host:

```bash
docker exec mysql mysql -uroot -p'YOUR_MYSQL_PASSWORD' rohit \
-e "SELECT * FROM registration;"
```

Current test data contains two registration records.

---

# 🖥️ MySQL GUI Access

Because Docker MySQL is mapped to host port `3307`, GUI applications such as DBeaver can connect directly.

Use:

```text
Host:     127.0.0.1
Port:     3307
Database: rohit
Username: root
Password: YOUR_MYSQL_PASSWORD
```

Do **not** use port `3306` for the Docker database.

Port `3306` belongs to the host MySQL installation.

---

# 🌐 Local Application Testing

Test from the Ubuntu server:

```bash
curl -I http://localhost:8081/register
```

Expected:

```text
HTTP/1.1 200
```

The registration page:

```text
http://localhost:8081/register
```

The data page:

```text
http://localhost:8081/fetch
```

---

# ☁️ Cloudflare Tunnel

The application is published through Cloudflare Tunnel.

Architecture:

```text
Internet
   │
   ▼
Cloudflare
   │
   ▼
spring-registration.rohitnet.dpdns.org
   │
   ▼
cloudflared
   │
   ▼
localhost:8081
   │
   ▼
Spring Boot Container
```

The public hostname is:

```text
spring-registration.rohitnet.dpdns.org
```

The Cloudflare tunnel forwards traffic to the local Spring application.

---

# 🔐 Security

## MySQL

The Docker MySQL container is not directly exposed to the internet.

The host mapping is:

```text
3307 → 3306
```

and is intended for local GUI/CLI access.

The Spring container accesses MySQL internally through:

```text
mysql:3306
```

## Database Password

Do not commit database passwords into:

* Git
* `application.properties`
* Dockerfiles
* README files
* public repositories

Use environment variables or secrets.

## Application Passwords

The current demonstration application stores registration passwords directly in the database.

For production applications, passwords should be securely hashed, for example using BCrypt, rather than storing plaintext passwords.

---

# 🔄 Restart and Reboot Behavior

Both application and database containers use:

```text
--restart unless-stopped
```

Therefore, after a server reboot, Docker can automatically start:

```text
mysql
spring-registration
```

The MySQL database remains persistent because it uses:

```text
mysql-data
```

---

# 🧪 Useful Docker Commands

### List containers

```bash
docker ps
```

### List all containers

```bash
docker ps -a
```

### View Spring logs

```bash
docker logs spring-registration
```

### Follow Spring logs

```bash
docker logs -f spring-registration
```

### View MySQL logs

```bash
docker logs mysql
```

### Inspect Spring environment

```bash
docker exec spring-registration env | grep '^DB_'
```

### Enter MySQL container

```bash
docker exec -it mysql mysql -uroot -p
```

### Check Docker networks

```bash
docker network ls
```

### Inspect application network

```bash
docker network inspect spring-net
```

### List volumes

```bash
docker volume ls
```

### Inspect MySQL volume

```bash
docker volume inspect mysql-data
```

---

# 🛠️ Troubleshooting

## Spring container is stopped

Check:

```bash
docker ps -a
```

Then:

```bash
docker logs spring-registration
```

Start it:

```bash
docker start spring-registration
```

---

## MySQL container is stopped

Check:

```bash
docker ps -a
```

Then:

```bash
docker logs mysql
```

Start it:

```bash
docker start mysql
```

---

## Spring cannot connect to MySQL

Check both containers:

```bash
docker ps
```

Check the Spring environment:

```bash
docker exec spring-registration env | grep '^DB_'
```

It should contain:

```text
DB_URL=jdbc:mysql://mysql:3306/rohit
```

Check the Docker network:

```bash
docker network inspect spring-net
```

Both containers should be connected to:

```text
spring-net
```

---

## `registration` table is missing

Check the Docker MySQL instance:

```bash
docker exec mysql mysql -uroot -p'YOUR_MYSQL_PASSWORD' rohit \
-e "SHOW TABLES;"
```

Do not confuse this with:

```bash
sudo mysql -u root -p
```

The latter connects to the separate host MySQL 8.0 installation.

---

# 🧠 Important Port Difference

```text
                 HOST MACHINE
                     │
       ┌─────────────┴─────────────┐
       │                           │
       ▼                           ▼
Host MySQL 8.0               Docker MySQL 9.7
localhost:3306               localhost:3307
       │                           │
       ▼                           ▼
customers                    registration
employees                    registration_seq
orders
```

Inside Docker:

```text
Spring Container
      │
      ▼
mysql:3306
      │
      ▼
Docker MySQL 9.7
```

Therefore:

```text
Spring → mysql:3306
DBeaver → localhost:3307
CLI → localhost:3307
```

---

# 📋 Deployment Summary

| Component           | Configuration                          |
| ------------------- | -------------------------------------- |
| OS                  | Ubuntu Server 24.04.x                  |
| Java                | 17                                     |
| Spring Boot         | 4.1.1                                  |
| Application         | Spring MVC + JSP                       |
| Application Port    | 8081                                   |
| Docker Network      | spring-net                             |
| MySQL Image         | mysql:9.7                              |
| MySQL Internal Port | 3306                                   |
| MySQL Host Port     | 3307                                   |
| Database            | rohit                                  |
| MySQL Volume        | mysql-data                             |
| Spring Container    | spring-registration                    |
| MySQL Container     | mysql                                  |
| Restart Policy      | unless-stopped                         |
| Public Access       | Cloudflare Tunnel                      |
| Public Hostname     | spring-registration.rohitnet.dpdns.org |

---

# 🏁 Final Architecture

```text
                         PUBLIC INTERNET
                                │
                                ▼
                         ┌─────────────┐
                         │ Cloudflare  │
                         └──────┬──────┘
                                │
                                ▼
             spring-registration.rohitnet.dpdns.org
                                │
                                ▼
                         cloudflared
                                │
                                ▼
                       localhost:8081
                                │
                                ▼
                 ┌─────────────────────────┐
                 │ spring-registration     │
                 │ Spring Boot             │
                 │ Java 17                 │
                 │ Port 8081               │
                 └───────────┬─────────────┘
                             │
                         spring-net
                             │
                             ▼
                 ┌─────────────────────────┐
                 │ mysql                   │
                 │ MySQL 9.7               │
                 │ Container Port 3306     │
                 │ Host Port 3307          │
                 └───────────┬─────────────┘
                             │
                             ▼
                       mysql-data
                             │
                             ▼
                           rohit
                             │
                  ┌──────────┴──────────┐
                  │                     │
          registration          registration_seq
```

## Current Status

The application is successfully:

* ✅ Built with Maven
* ✅ Packaged as a WAR
* ✅ Containerized with Docker
* ✅ Running on port `8081`
* ✅ Connected to Docker MySQL 9.7
* ✅ Using database `rohit`
* ✅ Persisting data in `mysql-data`
* ✅ Connected through Docker network `spring-net`
* ✅ Configured with automatic container restart
* ✅ Accessible through Cloudflare Tunnel
* ✅ Accessible publicly through the live domain
* ✅ Accessible from DBeaver/CLI through `localhost:3307`
* ✅ Confirmed to contain the `registration` table
* ✅ Confirmed to contain 2 registration records

