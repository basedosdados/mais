FROM python:3.9
WORKDIR /app
ENV PYTHONPATH=/app PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8
RUN pip install basedosdados==1.5.2 toml
COPY test_data.py /app/
CMD ["pytest"]