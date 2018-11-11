FROM ubuntu:cosmic
# ubuntu 18.10 (Cosmic Cuttlefish)

# curl, wget, https
RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \
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

# node 10.x
RUN curl -sL -o /tmp/setup_10.x.sh https://deb.nodesource.com/setup_10.x \
        && chmod +x /tmp/setup_10.x.sh \
        && /tmp/setup_10.x.sh \
        && apt-get install -y --no-install-recommends nodejs

# remove useless package
RUN apt-get remove -y cmdtest

# node global npms: serverless, graphql, yarn, typescript, ts-node, angular-cli
RUN npm install -g serverless
RUN npm install -g graphql-cli
RUN npm install -g yarn
RUN npm install -g typescript
RUN npm install -g ts-node
RUN npm install -g webpack
RUN npm install -g angular-cli

# python, pip, aws
RUN apt-get update && apt-get install -y --no-install-recommends \
		python-pip \
		python-setuptools \
		awscli \
	&& rm -rf /var/lib/apt/lists/*

# aws ecs-cli
RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest \
        && chmod +x /usr/local/bin/ecs-cli

# docker client
RUN set -x && VER="18.06.1-ce" \
        && curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz \
        && tar -xz -C /tmp -f /tmp/docker-$VER.tgz \
        && mv /tmp/docker/* /usr/bin

# inteliJ IDEA
RUN set -x && VER="2018.2.4" \
        && curl -L -o /tmp/ideaIU-$VER.tar.gz https://download.jetbrains.com/idea/ideaIU-$VER.tar.gz \
        && tar -xz -C /tmp -f /tmp/ideaIU-$VER.tar.gz \
        && mv /tmp/ideaIU-*/* /opt/idea \
        #&& /opt/idea/bin/ # link idea to /usr/bin
        ;
