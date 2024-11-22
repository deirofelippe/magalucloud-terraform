FROM python:3.13.0-alpine3.20

RUN apk update \
    # troubleshooting redes respectivamente: nc ss tcpdump curl ping
    # && apk add netcat-openbsd iproute2-ss tcpdump curl iputils-ping \
    && apk add make \
    && adduser -u 1000 --disabled-password --gecos "" py 

USER py

WORKDIR /home/py/app

ENV PYTHONUNBUFFERED=1 

COPY --chown=py:py ./requirements.txt ./

RUN pip install -r requirements.txt

COPY --chown=py:py ./ ./

CMD [ "/usr/bin/make", "py-server-prod" ]