<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Guacamole, verified and packaged by Elestio

[Guacamole](https://github.com/apache/guacamole-client/) is a personal document organizer. Or sometimes called a "Document Management System" (DMS). You'll need a scanner to convert your papers into files. 

<img src="https://raw.githubusercontent.com/elestio-examples/guacamole/main/screenshot.jpg" alt="guacamole" width="800">

[![deploy](https://github.com/elestio-examples/guacamole/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/guacamole)

Deploy a <a target="_blank" href="https://elest.io/open-source/guacamole">fully managed guacamole</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/guacamole.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

    mkdir -p ./pgdata
    chown -R 1000:1000 ./pgdata

Run the project with the following command

    docker-compose up -d
    ./scripts/postInstall.sh

You can access the Web UI at: `http://your-domain:9090`

## Docker-compose

Here are some example snippets to help you get started creating a container.

        version: "3.3"
        services:
        init-guac-db:
            image: elestio4test/guacamole-client:${SOFTWARE_VERSION_TAG}
            env_file:
            - .env
            command:
            [
                "/bin/sh",
                "-c",
                "test -e /init/initdb.sql && echo 'init file already exists' || /opt/guacamole/bin/initdb.sh --mysql > /init/initdb.sql",
            ]
            volumes:
            - ./init:/init

        mysql:
            image: mysql:8
            restart: "always"
            env_file:
            - .env
            volumes:
            - ./mysql:/var/lib/mysql/
            - ./init:/docker-entrypoint-initdb.d:ro
            environment:
            MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
            MYSQL_DATABASE: guacamole_db
            MYSQL_USER: guacamole_user
            MYSQL_PASSWORD: ${MYSQL_PASSWORD}
            #ucomment below if you want to expose an access to the db
            #ports:
            #  - '3306:3306'
            depends_on:
            - init-guac-db

        guacd:
            image: elestio4test/guacamole-server:latest
            env_file:
            - .env
            volumes:
            - ./drive:/drive:rw
            - ./record:/record:rw
            restart: always

        guac:
            image: elestio4test/guacamole-client:latest
            restart: always
            env_file:
            - .env
            ports:
            - "172.17.0.1:9090:8080"
            environment:
            GUACD_HOSTNAME: guacd
            MYSQL_HOSTNAME: mysql
            MYSQL_PORT: 3306
            MYSQL_DATABASE: guacamole_db
            MYSQL_USER: guacamole_user
            MYSQL_PASSWORD: ${MYSQL_PASSWORD}
            ##Uncomment below if you want to enable TOTP
            #TOTP_ENABLED: 'true'
            #TOTP_ISSUER: Apache Guacamole
            #TOTP_DIGITS: 6
            #TOTP_PERIOD: 30
            #TOTP_MODE: sha1
            depends_on:
            - mysql
            - guacd


### Environment variables

|         Variable           |      Value (example)       |
| :------------------------: | :------------------------: |
|    SOFTWARE_VERSION_TAG    |         latest             |
|    HOST_DOMAIN             |         DOMAIN             |
|    IP                      |         IP                 |
|    ADMIN_LOGIN             |         USER               |
|    ADMIN_PASSWORD          |         your_password      |
|    MYSQL_ROOT_PASSWORD     |         your_password      |
|    MYSQL_PASSWORD          |         your_password      |



# Maintenance

## Logging

The Elestio Guacamole Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://guacamole.apache.org/doc/gug/">Guacamole documentation</a>

- <a target="_blank" href="https://github.com/apache/guacamole-client/">Guacamole Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/guacamole">Elestio/Guacamole Github repository</a>
