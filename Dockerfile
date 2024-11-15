FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the application code
COPY ./app /app

# Set the working directory
WORKDIR /app

# Expose the default port
EXPOSE 8000


ARG DEV=false
# Install dependencies and create a virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
       then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \   
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Update the PATH environment variable
ENV PATH="/py/bin:$PATH"

# Use a non-root user
USER django-user
