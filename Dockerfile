FROM node:16
RUN npm install -g @ceramicnetwork/cli
RUN mkdir -p /root/.ceramic
ADD daemon.config.json /root/.ceramic/daemon.config.json
ENTRYPOINT ["ceramic", "daemon"]