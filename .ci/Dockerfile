FROM eclipse-temurin:17-jre

RUN mkdir /opt/kube

WORKDIR /opt/kube

COPY target/kube.jar /opt/kube/app.jar

CMD exec java $JAVA_OPTS -jar /opt/kube/app.jar
