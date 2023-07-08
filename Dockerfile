FROM ubuntu:22.04


RUN apt update
RUN apt install -y nginx

RUN apt install -y fuse
# dependencies
RUN apt install -y curl gnupg gnupg2 gnupg1
RUN echo "deb https://packages.cloud.google.com/apt gcsfuse-jammy main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt update && apt install gcsfuse

ENV GCP_CREDENTIALS=
ENV GCS_BUCKET_NAME=
ENV MNT_DIR=/mnt/gcs

RUN mkdir /mnt/gcs && echo "$GCP_CREDENTIALS" > /credentials.json
RUN cat /credentials.json
RUN gcsfuse --foreground --debug_fuse --debug_fs --debug_gcs --debug_http -o nonempty \
    --key-file /credentials.json $GCS_BUCKET_NAME $MNT_DIR
# 
# # for development
# RUN apt install gcsfuse
# RUN apt install -y sudo nano

EXPOSE 80