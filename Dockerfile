FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENV PYTHONDONTWRITEBYTECODE=1
CMD ["uvicorn", "auditia.api:app", "--host", "0.0.0.0", "--port", "8000"]
