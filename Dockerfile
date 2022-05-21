FROM tomcat:8

# Working Directory
WORKDIR /usr/local/tomcat/webapps

# Copy war file into container
COPY JavaCalculatorApp/target/JavaCalculatorApp.war ./JavaCalculatorApp.war

# Expose container port
EXPOSE 8080

# Set directory for volume
VOLUME /var/lib/javacalculator
