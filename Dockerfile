# Use uma imagem base com Java 23
FROM eclipse-temurin:23-jdk as build

# Diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos do projeto para o container
COPY . .

# Compila o projeto usando Maven (ou outra ferramenta)
RUN ./mvnw clean package -DskipTests

# Usa uma imagem menor para execução da aplicação
FROM eclipse-temurin:23-jre

# Diretório de trabalho para o runtime
WORKDIR /app

# Copia o artefato gerado no estágio anterior
COPY --from=build /app/target/*.jar app.jar

# Expõe a porta que o Spring Boot usará
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
