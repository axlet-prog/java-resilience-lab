# syntax=docker/dockerfile:1
FROM eclipse-temurin:25-jdk AS build
WORKDIR /src

ARG SERVICE

RUN test -n "$SERVICE" || \
    (echo "Передай --build-arg SERVICE=payment-service" >&2; exit 1)

COPY gradlew ./
COPY gradle/wrapper/ gradle/wrapper/
RUN ./gradlew --version --no-daemon

COPY settings.gradle.kts build.gradle.kts ./
COPY services/${SERVICE}/build.gradle.kts services/${SERVICE}/build.gradle.kts

COPY services/${SERVICE}/src/main/ services/${SERVICE}/src/main/

RUN --mount=type=cache,target=/root/.gradle/caches,sharing=locked \
    ./gradlew ":services:${SERVICE}:bootJar" --no-daemon --console=plain \
    && mkdir /app \
    && cp "services/${SERVICE}/build/libs/app.jar" /app/app.jar

RUN java -Djarmode=tools -jar /app/app.jar extract --layers --destination /app/extracted


FROM eclipse-temurin:25-jre-alpine
RUN apk upgrade --no-cache && addgroup -S app && adduser -S -G app app
WORKDIR /app
COPY --from=build /app/extracted/dependencies/ ./
COPY --from=build /app/extracted/spring-boot-loader/ ./
COPY --from=build /app/extracted/snapshot-dependencies/ ./
COPY --from=build /app/extracted/application/ ./
USER app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]