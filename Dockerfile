FROM ubuntu:20.04

RUN mkdir -p /works  \
    && mkdir -p /opt \
    && apt-get update && apt-get install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone \
    && apt-get install -y unzip build-essential git \
    && apt-get install -y openjdk-8-jdk \
    && apt-get install -y curl \
    && curl --location --remote-name --silent https://repo1.maven.org/maven2/com/vip/vjtools/vjtop/1.0.8/vjtop-1.0.8.zip \    
    && unzip vjtop-1.0.8.zip -d /opt \
    && rm vjtop-1.0.8.zip \
    && curl --location --remote-name --silent https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
    && tar -zxvf apache-maven-3.6.3-bin.tar.gz -C /opt \
    && mv /opt/apache-maven-3.6.3 /opt/maven \
    && rm apache-maven-3.6.3-bin.tar.gz \ 
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoclean \
    && du -sh /var/cache/apt/ \
    && rm -rf /var/cache/apt/archives

WORKDIR /works
ENV LANG=en_US.UTF-8 
ENV PATH="${PATH}:/opt/maven/bin:/opt/vjtop"

ENTRYPOINT [ "sh", "-c", "cd /works && bash" ]
