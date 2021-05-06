FROM python:3.8 AS base

#Install packages
RUN apt-get -y update
RUN apt-get -y install vim

FROM base AS requirements

WORKDIR /app

COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app
VOLUME /app

RUN python ELMoForManyLangs/setup.py install
