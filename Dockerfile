FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    openssh-server \
    wget \
    curl \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    golang \
    openjdk-11-jre-headless \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN wget https://archive.apache.org/dist/kafka/2.8.0/kafka_2.13-2.8.0.tgz && \
    tar -xzf kafka_2.13-2.8.0.tgz && \
    mv kafka_2.13-2.8.0 /opt/kafka && \
    rm kafka_2.13-2.8.0.tgz

RUN sed -i 's/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/' /opt/kafka/config/server.properties && \
    echo "advertised.listeners=PLAINTEXT://localhost:9092" >> /opt/kafka/config/server.properties

WORKDIR /project
COPY . /root/

EXPOSE 22 80 9092

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]