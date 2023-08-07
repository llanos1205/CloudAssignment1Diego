To run this project yo need to do the following

1.- have installed python and pip

2.- have installed python venv

3.- have installed sqlite , azurecli and awscli

4.- create virtual environment:

> python -m venv venv 

5.- install dependencies

> ./venv/lib/activate
> 
> pip install -r requirements.txt

6.- install migrations this will create the db if it doesnt exist in sqlite, 

you can change it to sql server if you want in the settings.py and pick any cloud provider as CLOUD_ENGINE

but youll have to fill the connexion options

> python manage.py makemigrations catalog

> python manage.py migrate catalog

> python manage.py makemigrations

> python manage.py migrate


7.- start server:

> python manage.py runserver