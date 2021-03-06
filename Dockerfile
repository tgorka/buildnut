FROM ubuntu:cosmic


# Define environment variable
ENV DOCKER_NAME buildnut
ENV DOCKER_SUBNAME latest

# noninteractive do not ask questions if he could. Default value is newt
ENV DEBIAN_FRONTEND noninteractive
ENV TZ 'Europe/London'
RUN echo $TZ > /etc/timezone

# install and set zsh as default shell
RUN apt-get update && apt-get install -y --no-install-recommends \
		zsh \
	&& rm -rf /var/lib/apt/lists/*
# update sourcing /etc/profile in zsh
RUN echo "[[ -e /etc/profile ]] && emulate sh -c 'source /etc/profile'" >> /etc/zsh/zprofile
RUN echo "[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'" >> /etc/zsh/zprofile
# use /etc/profile as non-login shell
ENV ENV="/etc/profile"
# use zsh in the shell env
ENV SHELL="/bin/zsh"
# change default shell to zsh
RUN chsh -s /bin/zsh
# use zsh in next docker RUN commands
SHELL ["/bin/zsh", "--login", "-c"]

# linux tools: curl, wget, https, rsnc
RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \
		rsync \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg \
			dirmngr \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi

# procps is very common in build systems, and is a reasonably small package
RUN apt-get update && apt-get install -y --no-install-recommends \
		git \
		openssh-client \
		build-essential \
		autoconf \
		procps \
	&& rm -rf /var/lib/apt/lists/*

# node 11.x
RUN set -x && VER="11.x" \
        && curl -sL -o /tmp/setup_$VER.sh https://deb.nodesource.com/setup_$VER \
        && chmod +x /tmp/setup_$VER.sh \
        && /tmp/setup_$VER.sh \
        && apt-get install -y --no-install-recommends nodejs \
        && unset VER
	
# remove useless package
RUN apt-get remove -y cmdtest

# node global npms: serverless, graphql, yarn, typescript, ts-node
RUN npm install -g serverless
RUN npm install -g graphql-cli
RUN npm install -g yarn
RUN npm install -g typescript
RUN npm install -g ts-node
RUN npm install -g webpack

# python, pip, aws
RUN apt-get update && apt-get install -y --no-install-recommends \
		python3.7 \
		python-pip \
		python3-pip \
		python-setuptools \
		python3-setuptools \
		awscli \
	&& rm -rf /var/lib/apt/lists/*
# python3 as default
RUN printf 'alias python=python3\nalias pip=pip3' | tee /etc/profile.d/alias_python.sh
	
# jdk
RUN apt-get update && apt-get install -y --no-install-recommends \
		default-jdk \
	&& rm -rf /var/lib/apt/lists/*

# aws ecs-cli
RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest \
        && chmod +x /usr/local/bin/ecs-cli

# docker client
RUN set -x && VER="18.09.0" \
        && curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz \
        && tar -xz -C /tmp -f /tmp/docker-$VER.tgz \
        && mv /tmp/docker/* /usr/bin \
        && unset VER

# use non-root user nut of the gorup build
RUN groupadd -g 999 nut && \
    useradd -r --create-home -u 999 -g nut build
#RUN adduser --disabled-password --gecos '' nut
#RUN usermod -aG build nut

# install sudo
RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
	&& rm -rf /var/lib/apt/lists/*

# add nut to sudo group
RUN usermod -aG sudo build
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# set current user
USER build
WORKDIR /home/build

# set subname as the tag
ENV DOCKER_SUBNAME build

# Make port 80 available to the world outside this container
#EXPOSE 80

# Run default app when the container start
#CMD ["python", "app.py"]
