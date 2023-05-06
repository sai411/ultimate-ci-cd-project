FROM openjdk
ARG artifact=target/spring-boot-web.jar
RUN mkdir my-java-app
WORKDIR my-java-app
COPY ${artifact} java-app.jar
EXPOSE 8080
CMD [ "java", "-jar", "java-app.jar" ]
