# Jenkins Docker in Docker Node.js Slave v1
Docker Jenkins slave image with Docker in Docker, Node.JS and additional tools 


This Jenkins slave image contains Docker client and nodes 11.x for build and test NodeJS based applications.
this image extends benhall/dind-Jenkins-agent:v2 image.

This concept gives us to dynamically spin up a Jenkins slave as Docker image builds our NodeJS based app and builds an image from our Dockerfile and finally deploy to the Docker host machine.You can pull this image to your local Docker host before adding it to the template -> docker pull romandulman/dind-jenkins-slave-nodejs *this recommended but not mandatory*
Also Docker plugin need to be installed in Jenkins with configured new Cloud with template and put this image in the Docker image section input.

## Docker Plugin Installation:
1) Within the Dashboard, select Manage Jenkins on the left.
2) On the Configuration page, select Manage Plugins.
3) Manage Plugins page will give you a tabbed interface. Click Available to view all the Jenkins plugins that can be installed.
4) Using the search box, search for Docker. There are multiple Docker plugins, select Docker using the checkbox under the Cloud Providers header.
5) Click Install without Restart at the bottom.
6) The plugins will now be downloaded and installed. Once complete, click the link Go back to the top page.
Your Jenkins server can now be configured to build Docker Images.


## Add Docker Agent:
Once the plugins have been installed, you can configure how they launch the Docker Containers. The configuration will tell the plugin which Docker Image to use for the agent and which Docker daemon to run the containers and builds on.

The plugin treats Docker as a cloud provider, spinning up containers as and when the build requires them.

## Configure docker.service.d
Before plugin configuration you should enable the remote API for dockerd (Docker Daemon):
After completing these steps, you will have enabled the remote API for dockerd, without editing the systemd unit file in place:

1) Create a file at ``` /etc/systemd/system/docker.service.d/startup_options.conf ``` with the below contents:

```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376
```

2) ``` $ sudo systemctl daemon-reload ```

3) ``` $ sudo systemctl restart docker.service ```

now the jenkins docker plugin can connect to the daemon.

## Configure Plugin:
This step configures the plugin to communicate with a Docker host/daemon.

7) Once again, select Manage Jenkins.

8) Select Configure System to access the main Jenkins settings.

9) At the bottom, there is a dropdown called Add a new cloud. Select Docker from the list.

10) The Docker Host URI is where Jenkins launches the agent container. In this case, we'll use the same daemon as running Jenkins, but 
you could split the two for scaling. Enter the URL tcp://your-docker-host-ip:2376

11) Use Test Connection to verify Jenkins can talk to the Docker Daemon. You should see the Docker version number returned.
The Host IP address is the IP of your build agent / Docker Host.

## Configure Docker Agent Template:
The Docker Agent Template is the Container which will be started to handle your build process.

12) Click Docker Agent templates... and then Add Docker Template. You can now configure the container options.

13) Set the label of the agent to docker-agent. This is used by the Jenkins builds to indicate it should be built via the Docker Agent we're defining.

14) For the Docker Image, use romandulman/dind-jenkins-slave-nodejs. This image is configured with a Docker client with NodeJS 11.x and available at https://hub.docker.com/r/romandulman/dind-jenkins-slave-nodejs

15) Under Container Settings, In the "Volumes" text box enter  /var/run/docker.sock:/var/run/docker.sock. This allows our build container to communicate with the host.

16) For Connect Method select Connect with SSH. The image is based on the Jenkins SSH Slave image meaning the default Inject SSH key will handle the authenication.

17) Make sure it is Enabled.

18) Click Save.

## Create New Job in Jenkins:
1) On the Jenkins dashboard, select Create new jobs

2) Give the job a friendly name such as Dcoker Jenkins Test Demo, select Freestyle project then click OK.
The build will depend on having access to Docker. Using the "Restrict where this project can be run" we can define the label we set of our configured Docker agent. The set "Label Expression" to docker-agent. You should have a configuration of "Label is serviced by no nodes and 1 cloud".
If you see the error message There’s no agent/cloud that matches this assignment. Did you mean ‘master’ instead of ‘docker-agent’?, then the Docker plugin and the Docker Agent has not been Enabled. Go back to configure the system options and enable both checkboxes.

#### we assume that you created Docker file with configurations for your NodeJS app
3) Select the your NodeJS project Repository type as Git and set it to your repository URL

4) Add Build step As "Build / Publish Docker Image" 

5) in the Directory for Dockerfile input section set the location where your Dockerfile in the project dir, which is used to build the image.

6) in The cloud input section, choose your newly created cloud name

7) in the image input section put ``` your-image-name:${BUILD_NUMBER} ```

8) Run the job and wait until it start the container slave, after that it will create new image with name
``` your-image-name:${BUILD_NUMBER} ``` in the Docker Host

9) you can now add a new build step using the Add Build Step dropdown. Select Execute Shell.
this simple script will tagging image and run container from newly created image and remove previous container every Jenkins build run

### shell script:
remove peviously running container, old image
```
   docker stop your-container-name
   docker rm  your-container-name
   docker rmi your-image-name:latest
   ```
   tagging the  new built image in step 8
   ```
   docker tag your-image-name:${BUILD_NUMBER}  your-image-name:latest
   docker run --name your-container-name  -d -p 80:3000  your-image-name:latest
``` 
#### for more help, you can contact me by Email:
#### romandulman@gmail.com
#### roman.dulman@opotel.com


### Resources and Credits:
#### https://www.katacoda.com/courses/jenkins/build-docker-images
