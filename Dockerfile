FROM python:3.10.10-alpine3.17

WORKDIR /app

COPY server/requirements.txt ./
RUN pip install -r requirements.txt

COPY ./server .

EXPOSE 8000

CMD ["python", "main.py"]