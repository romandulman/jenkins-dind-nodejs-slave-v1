FROM jenkins/ssh-slave

LABEL "org.label-schema.vendor"="Cloudutive RWT ltd" \
    version="1.0" \
    maintainer="roman.dulman@reactivewebtech.com" \
    description="Build, Test and Deploy as docker image Node.js 16.x projects"
    
RUN curl -sSL https://get.docker.com/ | sh
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh && bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN npm -g install typescript 
RUN npm -g install yarn 
