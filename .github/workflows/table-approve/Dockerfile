FROM python:3.9
WORKDIR /app
ENV PYTHONPATH=/app PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8

RUN pip install --pre basedosdados==1.5.1a0 toml
COPY main.py /app/
CMD ["python", "/app/main.py"]
