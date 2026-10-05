FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /opt/app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-alpine-3.21
WORKDIR /opt/app
COPY --from=build /opt/app/target/cp04-microservice-0.0.1-SNAPSHOT.jar /opt/app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
