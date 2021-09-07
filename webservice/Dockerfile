FROM ubuntu:18.04
RUN apt update
RUN apt install -y wget python-pip python-dev
WORKDIR /root
COPY . /root
RUN pip install -r requirements.txt
RUN chmod +x service.py
RUN wget https://github.com/Nukesor/pueue/releases/download/v0.12.2/pueue-linux-x86_64 -O /usr/bin/pueue && chmod +x /usr/bin/pueue
CMD [ "python",  "service.py" ]
