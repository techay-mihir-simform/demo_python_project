FROM python

RUN pip install asgiref && \
    pip install Django && \
    pip install djangorestframework && \
    pip install djoser && \
    pip install pytz && \
    pip install sqlparse
COPY . .
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
