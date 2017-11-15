FROM ubuntu:artful

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

# node 8.x
RUN curl -sL -o /tmp/setup_8.x.sh https://deb.nodesource.com/setup_8.x \
        && chmod +x /tmp/setup_8.x.sh \
        && /tmp/setup_8.x.sh \
        && apt-get install -y --no-install-recommends nodejs

# python, pip, aws, yarn
RUN apt-get update && apt-get install -y --no-install-recommends \
		python-pip \
		python-setuptools \
		awscli \
		yarn \
	&& rm -rf /var/lib/apt/lists/*

# docker client
RUN set -x && VER="17.09.0-ce" \
        && curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz \
        && tar -xz -C /tmp -f /tmp/docker-$VER.tgz \
        && mv /tmp/docker/* /usr/bin