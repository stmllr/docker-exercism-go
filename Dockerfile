FROM golang:alpine

RUN apk update && \
    apk add bash bash-completion vim curl gcc musl-dev

# Bash setup, since alpine bash is quite minimal
RUN adduser --uid ${USERID:-1000} --gecos "" -h /exercism --disabled-password -s bash exercism && \
    echo -e "\nsource /etc/profile.d/bash_completion.sh\n" >> /exercism/.bashrc && \
    echo -e "PS1='\u@\h:$PWD\$ '" >> /exercism/.bashrc && \
    echo -e "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /exercism/.bashrc && \
    chown exercism /exercism/.bashrc

# Install exercism
RUN wget https://github.com/exercism/cli/releases/download/v3.0.13/exercism-linux-64bit.tgz -O exercism.tgz && \
    mkdir exercism && \
    tar xfz exercism.tgz -C exercism && \
    cp exercism/shell/exercism_completion.bash /usr/share/bash-completion/completions/exercism && \
    cp exercism/exercism /usr/local/bin/exercism && \
    rm -rf exercism.tgz exercism 

USER exercism

# Install some go dev tools: dlv, golint, shadow
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.44.2 && \
    go install golang.org/x/lint/golint@latest && \
    go install golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /exercism

CMD bash

