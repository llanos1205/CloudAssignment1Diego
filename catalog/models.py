from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    pass

class Book(models.Model):
    name = models.CharField(max_length=255)
    author = models.CharField(max_length=255)
    available = models.BooleanField(default=True)
    reserved_by = models.ForeignKey('User', on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self):
        return self.name
