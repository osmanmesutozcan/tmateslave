Dockerized tmate slave server
=============================

Use prebuilt image:
    $ docker run osmanmesutozcan/tmateslave

Built your image and run:
    $ docker build -t tmateslave . && docker run -p 8000:22 tmateslave
