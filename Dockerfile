FROM centos:latest
MAINTAINER "FM-NBS"
RUN yum -y update
RUN yum -y install epel-release
RUN yum install -y python3
RUN yum install python3-pip

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt
COPY . /app

# set default flask app and environment
ENV FLASK_APP run
ENV FLASK_ENV development

# This is primarily a reminder that we need access to port 5000
EXPOSE 5000

# Change this to UID that matches your username on the host
# Note: RUN commands before this line will execute as root in the container
# RUN commands after will execute under this non-privileged UID
USER 1000

# Default cmd when container is started
# Use --host to make Flask listen on all networks inside the container
CMD flask run --host=0.0.0.0