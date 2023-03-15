# First stage: complete build environment
FROM maven:3.5.4-jdk-8-alpine AS builder

# add pom.xml and source code
ADD ./pom.xml pom.xml
ADD ./src src/

# package jar
RUN mvn clean package
# Second stage: minimal runtime environment
FROM eclipse-temurin:11
RUN mkdir /opt/app

# copy jar from the first stage
COPY --from=builder target/my-app-1.0-SNAPSHOT.jar /opt/app/my-app-1.0-SNAPSHOT.jar

EXPOSE 8080
EXPOSE 9090

CMD ["java", "-Dcom.sun.management.jmxremote", "-Dcom.sun.management.jmxremote.local.only=false", "-Dcom.sun.management.jmxremote.port=9090", "-Dcom.sun.management.jmxremote.authenticate=false", "-Dcom.sun.management.jmxremote.ssl=false", "-Dcom.sun.management.jmxremote.rmi.port=9090", "-Dcom.sun.management.jmxremote.verbose=true", "-jar", "/opt/app/my-app-1.0-SNAPSHOT.jar"]
