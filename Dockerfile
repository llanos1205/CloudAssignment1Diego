FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN python -m venv venv
RUN . venv/bin/activate && pip install -r requirements.txt

# Copy the application code
COPY . .

# Set the container command
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
