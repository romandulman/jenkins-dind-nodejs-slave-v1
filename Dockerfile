FROM jenkins/ssh-slave

RUN curl -sSL https://get.docker.com/ | sh
RUN curl -sL https://deb.nodesource.com/setup_11.x -o nodesource_setup.sh && bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN npm install -g typescript && npm -g install selenium-node-webdriver && npm -g install karma 
&& npm -g install mocha && npm install -g cucumber
