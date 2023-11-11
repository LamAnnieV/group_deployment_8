FROM python:3.9

RUN git clone https://github.com/LamAnnieV/group_deployment_8.git

WORKDIR /group_deployment_8/backend

RUN pip install -r requirements.txt

EXPOSE 8000

RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
