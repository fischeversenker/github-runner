FROM ubuntu:18.04

# Set some default env variables for the user
ENV GITHUB_TOKEN 'not-set'
ENV GITHUB_REPO_URL 'not-set'
ENV GITHUB_RUNNER_VERSION '2.272.0'

RUN echo "create github user" && \
    adduser --system --group github

WORKDIR /home/github

RUN echo "install dependencies" && \
    apt-get update && apt-get install curl libicu60 -y

RUN echo "install github-runner" && \
    curl -O -L https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz

RUN echo "copy start script and give permission"
COPY start.sh ./start.sh
RUN chmod a+x ./start.sh ./config.sh ./run.sh

USER github

ENTRYPOINT ["./start.sh" ]
