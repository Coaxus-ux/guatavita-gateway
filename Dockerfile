# 1) Build con Maven + JDK 17
FROM maven:3-openjdk-17-slim AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 2) Runtime en WildFly con Java 17
FROM quay.io/wildfly/wildfly:28.0.1.Final-jdk17

USER root
# Copiamos el WAR generado
COPY --from=build /app/target/*.war /opt/jboss/wildfly/standalone/deployments/app.war
# Exponemos puertos HTTP (8080) y management (9990)
EXPOSE 8080 9990
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
