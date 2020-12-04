---
title: Minio as local S3 replacement
date: 2019-05-18T19:49:11+01:00
subtitle: 'Tips for using minio'
description: ''
tags: [ s3, storage, cloud]
draft: true
---


## Installation

My docker image at ejsmit/minio.  Unlike official image mine supports both amd4 and arm.

```
docker run -p 9000:9000 \
  -e "MINIO_ACCESS_KEY=access_key" \
  -e "MINIO_SECRET_KEY=secret_key" \
  ejsmit/minio server /data
```


## Web interface

http://servername:9000

Create buckets, add & view files, etc.



## Python libraries

Use `boto3` to access minio storage.

Sample code from minio website:

```
#!/usr/bin/env/python
import boto3
from botocore.client import Config

s3 = boto3.resource('s3',
                    endpoint_url='http://localhost:9000',
                    aws_access_key_id='YOUR-ACCESSKEYID',
                    aws_secret_access_key='YOUR-SECRETACCESSKEY',
                    config=Config(signature_version='s3v4'),
                    region_name='us-east-1')

# upload a file from local file system '/home/john/piano.mp3' to bucket 'songs' with 'piano.mp3' as the object name.
s3.Bucket('songs').upload_file('/home/john/piano.mp3','piano.mp3')

# download the object 'piano.mp3' from the bucket 'songs' and save it to local FS as /tmp/classical.mp3
s3.Bucket('songs').download_file('piano.mp3', '/tmp/classical.mp3')

print "Downloaded 'piano.mp3' as  'classical.mp3'. "
```

## References

* <https://docs.min.io/docs/how-to-use-aws-sdk-for-python-with-minio-server.html>
* <https://docs.min.io/docs/python-client-quickstart-guide.html>
* <https://hub.docker.com/r/minio/minio/>




