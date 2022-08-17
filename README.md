# Guacamole on Elestio with CI/CD

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/guacamole"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Example CI/CD pipeline showing how to deploy Guacamole on Elestio.

# Once deployed ...

You are now able to sign to the Admin UI here:
    
    https://[CI_CD_DOMAIN]/guacamole
    login: root
    password: (set in env var ADMIN_PASSWORD)


# Quick start

Login with admin credentials;
Go to Settings -> Connections (pop-up menu at the top right);
Create a new connection.

Documentation: 
https://guacamole.apache.org/doc/1.4.0/gug/