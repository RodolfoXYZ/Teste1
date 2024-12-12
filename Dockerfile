# Cria uma imagem Maven personalizada com base no Java 23
FROM openjdk:23-jdk AS maven

RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Agora, use esta imagem no estágio de build
# Copia arquivos e compila
COPY pom.xml . 
RUN mvn dependency:resolve
COPY src ./src
RUN mvn clean package -DskipTests

# Estágio final com Java 23 para rodar o aplicativo
FROM openjdk:23-jdk

WORKDIR /app

COPY --from=maven /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
