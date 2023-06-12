#set env vars
set -o allexport; source .env; set +o allexport;

# Init guacamole database
docker-compose up init-guac-db

#Add new admin user and block default user guacadmin
cat > ./mysql/add.sql << EOF
INSERT INTO guacamole_entity (entity_id, name, type) VALUES ('2', '${ADMIN_LOGIN}', 'USER');
SET @salt = UNHEX(SHA2(UUID(), 256));
INSERT INTO guacamole_user (entity_id, password_salt, password_hash, password_date) VALUES ('2', @salt, UNHEX(SHA2(CONCAT('${ADMIN_PASSWORD}', HEX(@salt)), 256)), NOW());
INSERT INTO guacamole_user_permission (entity_id, affected_user_id, permission) VALUES ('2', '2', 'READ'), ('2', '2', 'UPDATE'), ('2', '2', 'ADMINISTER');
INSERT INTO guacamole_system_permission (entity_id, permission) VALUES ('2', 'CREATE_CONNECTION'), ('2', 'CREATE_CONNECTION_GROUP'), ('2', 'CREATE_SHARING_PROFILE'),('2', 'CREATE_USER'),('2', 'CREATE_USER_GROUP'),('2', 'ADMINISTER');
UPDATE guacamole_user SET disabled='1' WHERE user_id='1';
GRANT ALL PRIVILEGES ON *.* TO 'guacamole_user'@'%' WITH GRANT OPTION;
EOF

sleep 10s;

docker-compose exec -T mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} guacamole_db < ./mysql/add.sql