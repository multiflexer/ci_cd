FROM maven:3.5.2-jdk-8-alpine
 
ADD src src
ADD pom.xml .
 
RUN mvn compile
CMD mvn exec:java -Dexec.mainClass="com.mycompany.app.App"
