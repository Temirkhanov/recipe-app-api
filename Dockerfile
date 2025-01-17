FROM python:3.7-alpine
MAINTAINER Ruslan Temirkhanov

# Set Env Variable
# Run unbuffered mode of Python. Recommended when running python within docker container.
# Doesn't allow python to buffer the outputs, just prints it directly.
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

# Create directory to store source code
RUN mkdir /app
# Switches to this directory as a default directory
WORKDIR /app
# Copies app folder to take a code into a docker image
COPY ./app /app

# Create a user that is gonna run our applciation as user
RUN adduser -D user
# Switch to the user
USER user