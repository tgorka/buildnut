FROM ubuntu:artful

# remove useless package
RUN apt-get remove -y cmdtest

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
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
		\
		procps \
	&& rm -rf /var/lib/apt/lists/*

# node 9.x
RUN curl -sL -o /tmp/setup_9.x.sh https://deb.nodesource.com/setup_9.x \
        && chmod +x /tmp/setup_9.x.sh \
        && /tmp/setup_9.x.sh \
        && apt-get install -y --no-install-recommends nodejs
	
# node global npms: serverless
RUN npm install -g serverless
RUN npm install -g graphql-cli
RUN npm install -g yarn

# python, pip, aws, yarn
RUN apt-get update && apt-get install -y --no-install-recommends \
		python-pip \
		python-setuptools \
		awscli \
	&& rm -rf /var/lib/apt/lists/*

# aws ecs-cli
RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest \
        && chmod +x /usr/local/bin/ecs-cli

# docker client
RUN set -x && VER="17.09.0-ce" \
        && curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz \
        && tar -xz -C /tmp -f /tmp/docker-$VER.tgz \
        && mv /tmp/docker/* /usr/bin
