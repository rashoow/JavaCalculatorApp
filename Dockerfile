#FROM lolhens/baseimage-openjre
FROM tomcat:8.5.47-jdk8-openjdk

# Working Directory
WORKDIR /usr/src/javacalculator

# Copy war file into container
#ADD ./JavaCalculatorApp.war ./
#ADD JavaCalculatorApp/target/JavaCalculatorApp.war JavaCalculatorApp.war
COPY JavaCalculatorApp/target/JavaCalculatorApp.war ./JavaCalculatorApp.war

# Expose container port
EXPOSE 3000

# Set directory for volume
VOLUME /var/lib/javacalculator

CMD ["catalina.sh", "run"]
