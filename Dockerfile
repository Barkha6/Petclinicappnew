FROM openjdk:8 AS BUILD_IMAGE
RUN apt update && apt install maven -y
RUN git clone https://github.com/Barkha6/Petclinicappnew.git
RUN cd Petclinicappnew && mvn install

FROM tomcat:8-jre11

#remove default 
RUN rm -rf /usr/local/tomcat/webapps/*

#copy build 
COPY --from=BUILD_IMAGE Petclinicappnew/target/ /usr/local/tomcat/webapps/ROOT.jar


EXPOSE 9090
CMD ["catalina.sh", "run"]
