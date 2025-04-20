# Use the official Maven image to build the WAR file
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and the src directory (only necessary files for the build)
COPY pom.xml .
COPY src ./src

# Run Maven to build the WAR file (skip tests for faster build)
RUN mvn clean package -DskipTests

# Use the official Tomcat image to deploy the WAR file
FROM tomcat:9.0

# Remove the default web apps (if any) to avoid conflict
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage into the Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 to access the application
EXPOSE 8080

# Start the Tomcat server
CMD ["catalina.sh", "run"]
