FROM python:3.9
WORKDIR /app
ENV PYTHONPATH=/app PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8

RUN pip install --upgrade toml tomlkit 
RUN ls -a
# RUN pip install -r "../../requirements-dev.txt"
# RUN python "../../setup.py" develop
COPY main.py /app/
CMD ["python", "/app/main.py"]