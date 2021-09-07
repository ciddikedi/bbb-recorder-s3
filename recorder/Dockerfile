FROM  node
WORKDIR /root

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -y update
RUN apt-get -y install google-chrome-stable
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:jonathonf/ffmpeg-4
RUN apt-get -y install ffmpeg
RUN apt -y install xvfb
RUN apt-get -y install ruby-full
RUN gem install yaml aws-sdk-s3 fileutils trollop optparse

COPY * /root/bbb-recorder/
RUN cd bbb-recorder && npm install --ignore-scripts
WORKDIR /root/bbb-recorder
ENTRYPOINT ["/root/bbb-recorder/mp4_recorder.rb"]
