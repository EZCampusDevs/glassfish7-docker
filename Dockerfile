FROM eclipse-temurin:11
RUN mkdir /opt/app
COPY glassfish/ /opt/app


# # manually do stuff
# CMD ["java", "-jar", "/opt/app/glassfish7/glassfish/lib/client/appserver-cli.jar", "--interactive"]

# # start server??
# CMD ["java", "-jar", "/opt/app/glassfish7/glassfish/modules/admin-cli.jar", "start-domain", "--verbose"]

RUN echo "grant { permission java.net.SocketPermission \"localhost:1527\", \"listen\"; };" >> $JAVA_HOME/lib/security/java.policy


# # Secure GF installation with a password and authorize network access
ADD password_1.txt /tmp/password_1.txt
ADD password_2.txt /tmp/password_2.txt
RUN /opt/app/glassfish7/glassfish/bin/asadmin --user admin --passwordfile /tmp/password_1.txt change-admin-password --domain_name domain1 \
    ; /opt/app/glassfish7/glassfish/bin/asadmin start-domain domain1 \
    ; /opt/app/glassfish7/glassfish/bin/asadmin --user admin --passwordfile /tmp/password_2.txt enable-secure-admin \
    ; /opt/app/glassfish7/glassfish/bin/asadmin stop-domain domain1
RUN rm /tmp/password_?.txt


CMD ["java", "-jar", "/opt/app/glassfish7/glassfish/lib/client/appserver-cli.jar", "start-domain", "--verbose"]

EXPOSE 4848