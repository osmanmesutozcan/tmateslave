Dockerized tmate slave server
=============================

Built your image and run:
    $ docker build -t tmateslave . && docker run --privileged -p 8000:22 tmateslave
