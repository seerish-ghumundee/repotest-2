FROM openjdk:21 as builder
WORKDIR application
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM eclipse-temurin:21
WORKDIR application
COPY --from=builder application/dependencies/ ./
RUN true
COPY --from=builder application/snapshot-dependencies/ ./
RUN true
COPY --from=builder application/application/ ./
RUN true
COPY --from=builder application/spring-boot-loader/ ./
RUN true
ENTRYPOINT ["java", "-Duser.timezone=Asia/Muscat", "-XX:InitialRAMPercentage=25", "-XX:MaxRAMPercentage=75", "-XX:+UseStringDeduplication", "-XX:+UseG1GC", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=/opt/spsis-mw/logs", "org.springframework.boot.loader.launch.JarLauncher"]
