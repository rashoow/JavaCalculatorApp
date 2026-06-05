# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY JavaCalculatorApp/pom.xml .
COPY JavaCalculatorApp/src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:9-jre17

# Working Directory
WORKDIR /usr/local/tomcat/webapps

# Copy war file into container
RUN rm -rf ROOT
COPY --from=build /app/target/JavaCalculatorApp.war ./ROOT.war

# Expose container port
EXPOSE 8080

# Set directory for volume
VOLUME /var/lib/javacalculator
