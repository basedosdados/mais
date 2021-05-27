FROM python:3.9
WORKDIR /app
ENV PYTHONPATH=/app PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8
RUN pip install basedosdados==1.5.2 pytest toml
COPY test_data.py /app/
COPY bd_credential.py /app/
COPY checks.yaml /app/
CMD ['pytest',"/app/test_data.py"]
