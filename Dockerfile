FROM python:3.12-alpine3.17

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY src/* /

RUN apk add --no-cache git bash curl jq && \
    curl -L -o gh.tar.gz https://github.com/cli/cli/releases/download/v2.82.1/gh_2.82.1_linux_amd64.tar.gz && \
    tar -xzf gh.tar.gz && \
    mv gh_*/bin/gh /usr/local/bin/gh && \
    rm -rf gh_* gh.tar.gz

RUN pip install --no-cache-dir -r /requirements.txt && \
    poetry config virtualenvs.create false --local && \
    poetry install --no-root && \
    pip install --upgrade "packaging>=24.0"

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
