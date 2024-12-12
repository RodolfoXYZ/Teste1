# Usa imagem Maven para compilar o projeto
FROM maven:3.9.5-eclipse-temurin-17 AS build

WORKDIR /app

# Copia o arquivo pom.xml e baixa dependências do projeto
COPY pom.xml . 
RUN mvn dependency:resolve

# Copia o código-fonte e compila o projeto
COPY src ./src
RUN mvn clean package -DskipTests

# Usa imagem OpenJDK para rodar o aplicativo
FROM openjdk:23-jdk

WORKDIR /app

# Copia o JAR gerado do estágio anterior
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
