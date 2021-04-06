
# Use an official Python runtime as a parent image
FROM ubuntu:18.04

# Set the working directory to /app
WORKDIR /app

RUN apt-get update && apt-get install -y locales
 
## Set LOCALE to UTF8

RUN apt-get update
RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Copy the current directory contents into the container at /app
COPY . /app
VOLUME /app
USER root
RUN \
  apt-get update && \
  apt-get install -y python3.7 python-dev python3-pip python3-virtualenv && \
  rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && apt-get install -y libgtk2.0-dev python python-dev python3 python3-dev python3-pip

RUN apt-get update && apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

RUN pip3 install setuptools pip --upgrade --force-reinstall

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]


# Install any needed packages specified in requirements.txt
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt


# Run setup.py when the container launches
#CMD ["python3", "./ELMoForManyLangs/setup.py"]
