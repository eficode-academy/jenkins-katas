FROM adoptopenjdk/openjdk11-openj9:alpine-slim
LABEL author="Sofus Albertsen"
COPY build/libs/complete-*-all.jar complete.jar
EXPOSE 8080
CMD java -Dcom.sun.management.jmxremote -noverify ${JAVA_OPTS} -jar complete.jar