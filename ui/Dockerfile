FROM tgorka/buildnut:latest

# set subname as the tag
ENV DOCKER_SUBNAME ui
# default display host set for the docker host network
ENV DISPLAY host.docker.internal:0.0

# browser: firefox, chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
        firefox \
        #chromium-browser \
        #chromium-codecs-ffmpeg \
        #chromium-codecs-ffmpeg-extra \
        #flashplugin-installer \
	&& rm -rf /var/lib/apt/lists/*