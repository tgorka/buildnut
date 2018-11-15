FROM tgorka/buildnut:latest

# set subname as the tag
ENV DOCKER_SUBNAME dev
# default display host set for the docker host network
ENV DISPLAY host.docker.internal:0.0

# update package list
RUN sudo apt-get update

# ssh server
RUN sudo apt-get install -y --no-install-recommends openssh-server
RUN sudo mkdir /var/run/sshd
RUN sudo echo 'root:screencast' | chpasswd
RUN sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sudo sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN sudo echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["sudo", "/usr/sbin/sshd", "-D"]

# browser: firefox, chromium
RUN sudo apt-get install -y --no-install-recommends \
        firefox \
        #chromium-browser \
        #chromium-codecs-ffmpeg \
        #chromium-codecs-ffmpeg-extra \
        #flashplugin-installer