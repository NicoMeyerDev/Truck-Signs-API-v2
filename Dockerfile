FROM python:3.13-slim-trixie

WORKDIR /app

RUN apt-get update && apt-get install -y netcat-traditional && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install -r  requirements.txt

COPY . /app

RUN chmod +x entrypoint.sh

EXPOSE 8000 

ENTRYPOINT ["/app/entrypoint.sh"]
