# Stage 1: Build the application
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# Copy Gradle build files and dependencies
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle
RUN ./gradlew dependencies --no-daemon

# Copy source code
COPY src ./src

# Build the application
RUN ./gradlew build --no-daemon

# Stage 2: Run the application
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port 8080 to allow external connections
EXPOSE 8080

# Command to run the Spring Boot application
CMD ["java", "-jar", "app.jar"]
