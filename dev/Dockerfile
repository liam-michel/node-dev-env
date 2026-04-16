FROM ubuntu:latest

ARG USER_ID
ARG GROUP_ID

#install and update basic deps

RUN apt-get update && apt-get install -y \ 
    adduser \
    curl \
    bash \
    git \ 
    nano \
    rsync \
    sudo \
    jq \ 
    unzip \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*


#set starting working directory
WORKDIR /tmp

#copy in user-group.sh script
COPY scripts /tmp/scripts
COPY code /tmp/code



#make the user-group script executable
RUN chmod +x /tmp/scripts/user-group.sh 

#run the script to create the user and group
RUN /tmp/scripts/user-group.sh ${USER_ID} ${GROUP_ID}

#switch to root to move files around 
USER root

#move executables and template to proper locations
RUN mkdir -p /home/dev-user/template \
    && mv /tmp/code/* /home/dev-user/template/ \
    && mv /tmp/scripts/entrypoint.sh /usr/local/bin/entrypoint \
    && mv /tmp/scripts/user-group.sh /usr/local/bin/user-group \
    && mv /tmp/scripts/newproject.sh /usr/local/bin/newproject \
    && chown -R dev-user:dev-user /home/dev-user/template \
    && chown dev-user:dev-user /usr/local/bin/*

#clean up tmp directory
RUN rm -rf /tmp/scripts /tmp/code

#switch to the new user
USER dev-user
WORKDIR /home/dev-user/dev-environment

#install nvm and Bun 
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install --lts \
    && npm install -g bun

#make executables executable
RUN sudo chmod +x /usr/local/bin/entrypoint && sudo chmod +x /usr/local/bin/newproject

#update path ENV
ENV PATH="/usr/local/bin:${PATH}"

#expose port for debugger (9229 node debugger port)
EXPOSE 9229

ENTRYPOINT ["/usr/local/bin/entrypoint"]



