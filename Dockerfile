FROM ubuntu:18.04

ENV GITHUB_RUNNER_VERSION '2.272.0'

# create github user
RUN adduser --system --group github && \
    usermod -aG sudo github

# switch to new home dir
WORKDIR /home/github

# install dependencies
RUN apt-get update && apt-get install curl libicu60 -y

# install github-runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz

# remove obsolete files
RUN rm ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz

# copy start script
COPY start.sh ./start.sh

# grant ownership of home folder to user github
RUN chown -R github:github /home/github

USER github

ENTRYPOINT ["./start.sh" ]
