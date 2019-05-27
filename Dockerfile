FROM jenkins/ssh-slave

LABEL "org.label-schema.vendor"="OPOTEL ltd" \
    version="1.0" \
    maintainer="roman.dulman@opotel.com" \
    description="Build, Test and Deploy as docker image Node.js projects"
    
RUN curl -sSL https://get.docker.com/ | sh
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN npm install -g typescript  
RUN npm -g install selenium-node-webdriver
RUN npm -g install karma
RUN npm -g install mocha
RUN npm -g install chai
RUN npm -g install cucumber
