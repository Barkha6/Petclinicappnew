FROM openjdk:8 AS BUILD_IMAGE
RUN apt update && apt install maven -y
#RUN git clone https://github.com/Barkha6/Petclinicappnew.git
#RUN cd Petclinicappnew && mvn install

FROM tomcat:8-jre11

#remove default 
RUN rm -rf /usr/local/tomcat/webapps/*

#copy build 
COPY /var/lib/jenkins/workspace/petclinicapp-new/target/spring-petclinic-2.7.3.war /usr/local/tomcat/webapps/ROOT.war


EXPOSE 8080
CMD ["catalina.sh", "run"]
