# ── Etapa 1: compilación con Maven ──────────────────────────────────
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copiar pom.xml primero para aprovechar la caché de capas de Docker.
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN ./mvnw dependency:go-offline -q 2>/dev/null || mvn dependency:go-offline -q

COPY src ./src
RUN ./mvnw clean package -DskipTests -q || mvn clean package -DskipTests -q

# ── Etapa 2: imagen de producción (solo JRE) ─────────────────────────
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Configurar usuario no root para mejorar la seguridad del contenedor en producción
# Se crea un grupo y un usuario llamado 'spring'
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

# Copiar únicamente el JAR compilado desde la etapa de builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
