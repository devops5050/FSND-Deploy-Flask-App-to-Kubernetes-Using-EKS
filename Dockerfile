FROM python:stretch

RUN mkdir /app

COPY requirements.txt /app
COPY main.py /app

WORKDIR /app

RUN apt-get update -y
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

ENTRYPOINT ["gunicorn", "-b", ":8080", "main:APP"]