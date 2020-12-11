FROM ubuntu:18.04

ENV GITHUB_RUNNER_VERSION 2.272.0

# switch to new home dir
WORKDIR /app/github-runner

# install dependencies and github-runner
RUN apt-get update && apt-get install curl -y && \
    curl -O -L https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz && \
    ./bin/installdependencies.sh && \
    echo "remove obsolete files" && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    rm ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz

# copy start script
COPY start.sh ./start.sh

# grant ownership of home folder to user of root group
RUN chgrp -R 0 /app/github-runner && \
    chmod -R g=u /app/github-runner

# make entrypoint executable
RUN chmod +x ./start.sh

USER 1001

ENTRYPOINT ["./start.sh" ]
