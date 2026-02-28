FROM alpine
#VERSION
RUN cat '/etc/os-release' && sleep 10
ENV PYTHONUNBUFFERED=1

RUN set -x \
RUN echo "**** install Python ****" && \
    apk add --update --no-cache python3-dev && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    echo "**** install pip ****" && \
    python3 -m venv --system-site-packages /usr/local && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    echo "**** install ****" && \
    apk add --update --no-cache \ 
    dcron \
    supervisor \
    tzdata \
    jpeg-dev \
    zlib-dev \
    libffi-dev \
    gcc \
    bash \
    curl \
    sudo \
    unzip \
    build-base \
    musl-dev \
    libffi-dev \
    make \
    alpine-sdk \
    linux-headers \ 
    inotify-tools \
    git \
    zip \
    fuse3 \
    py3-tornado \
    py3-pillow \
    py3-psutil \
    py3-cffi \
    py3-sqlalchemy \
    py3-markupsafe \
    py3-six \ 
    py3-pygments \
    py3-dulwich \  
    py3-flask \
    py3-opencv \
    py3-docutils \
    py3-pycryptodome \
    py3-cryptography \
    fribidi-dev \
    harfbuzz-dev \ 
    && rm -rf /var/cache/apk/*
#TIMEZONE
ENV TZ Asia/Seoul

#LANG
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8
ENV LIBRARY_PATH=/lib:/usr/lib
COPY supervisord.conf /etc/
COPY requirements.txt /requirements.txt
RUN chmod 777 /requirements.txt
RUN sed -i 's/providers = provider_sect/ssl_conf = ssl_sect/' /etc/ssl/openssl.cnf  && \
    sed -i'' -r -e "/ssl_conf = ssl_sect/a\[ssl_sect]" /etc/ssl/openssl.cnf  && \
    sed -i'' -r -e "/\[ssl_sect\]/a\system_default = system_default_sect" /etc/ssl/openssl.cnf  && \
    sed -i'' -r -e "/system_default = system_default_sect/a\[system_default_sect]" /etc/ssl/openssl.cnf  && \
    sed -i'' -r -e "/\[system_default_sect\]/a\Options = UnsafeLegacyRenegotiation" /etc/ssl/openssl.cnf  && \
    echo "ssl edit ok"
#RUN pip install -r /requirements.txt
RUN pip install --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine/ -r requirements.txt
ADD root /
RUN chmod +x /root/*
WORKDIR /app
HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://www.google.com || exit 1
CMD ["/root/init.sh"]
