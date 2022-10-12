# Setup DB

## 1. PostgreSQL

**Note**:

- Version install: `12`

### **a. Basic Setup**

- Install PostgreSQL

  ```bash
  sudo apt update
  sudo apt install postgresql postgresql-contrib

  # config init when os startup
  sudo systemctl enable postgresql
  # start service
  sudo systemctl start postgresql
  # show status current
  sudo systemctl status postgresql
  ```

- Change max_connections & shared_buffers:

  - Calculate max connection: 8 _ 1024 _ 1024 \* 1024 / 9531392 (901 connection)

  ```bash
  sudo nano /etc/postgresql/12/main/postgresql.conf
  # update 2 content bellow

  # (default is 100, total set flow with instance type: https://sysadminxpert.com/aws-rds-max-connections-limit/)
  max_connections = 210
  shared_buffers = 128MB

  sudo systemctl restart postgresql
  ```

### **b. Grant Permission**

- Make user `Root` & `Enable remote authenticate` config:

  ```bash
  # Change pass super user (user: postgres)
  sudo -u postgres psql
  \password postgres      # --> After that, enter the new password (nm22x#1818150)

  # Enable remote config
    nano /etc/postgresql/13/main/postgresql.conf
      # --> uncomment & change section content listen_addresses = 'localhost' => listen_addresses = '*'
    nano /etc/postgresql/13/main/pg_hba.conf
      # --> Add the following content to the bottom of the file: host all all 0.0.0.0/0 md5
    # Restart --> apply new config
    sudo systemctl restart postgresql
  ```

- Make `new user` & `Grant permission` access specified resource:

  ```sql
  -- For DEV environment
  -- ex: make all permission access specified database svm-iam-dev
  CREATE DATABASE "lab-core-dev";
  CREATE USER labcoredev WITH PASSWORD '1234';
  GRANT ALL PRIVILEGES ON DATABASE "lab-core-dev" to labcoredev;
  ```

  ```sql
  -- For STAGE environment
  -- ex: make all permission access specified database svm-iam-dev
  CREATE USER "labcorestage" WITH PASSWORD '1234';
  ALTER USER "labcorestage" WITH LOGIN;

  CREATE DATABASE "lab-core-stage";
  GRANT CONNECT ON DATABASE "lab-core-stage" TO "labcorestage";
  GRANT ALL PRIVILEGES ON DATABASE "lab-core-stage" to "labcorestage";
  ```

- GRANT ONLY SELECT PERMISSION FOR ROLE

  ```sql
  \c lab-core-dev
  GRANT SELECT ON ALL TABLES IN SCHEMA public TO labcoretester;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO labcoretester;
  ```

  ```sql
  \c lab-core-stage
  GRANT SELECT ON ALL TABLES IN SCHEMA public TO labcoretester;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO labcoretester;
  ```

## 2. Mysql

**Note**:

- Version install: `5.8`

### **a. Basic Setup**

```bash
sudo docker run --name lab-uat-local -p 3306:3306 --platform linux/amd64 -e MYSQL_ROOT_PASSWORD=1234 -d mysql:5.7
sudo docker run --name lab-uat-local -p 3306:3306 -e MYSQL_ROOT_PASSWORD=1234 -d mysql:5.8
docker run --name VMO-mack-dev -e MYSQL_ROOT_PASSWORD=1234 --platform linux/amd64 --publish 3306:3306 -d mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci  --lower_case_table_names=1


docker exec -it <id> /bin/bash
mysql -u root -p

```

```sql


CREATE DATABASE lab_uat CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE lab_uat CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER 'Appuser'@'%' IDENTIFIED BY '@ppu$er321'; // CREATE USER 'Appuser'@'%';
GRANT ALL PRIVILEGES ON db_uat.* TO 'Appuser'@'%'; // GRANT ALL PRIVILEGES ON lab_uat.* To 'Appuser'@'%' IDENTIFIED BY '@ppu$er321';

FLUSH PRIVILEGES;


cat dump-202208080320.sql | docker exec -i 16f mysql -uroot -p1234 db_uat

```
