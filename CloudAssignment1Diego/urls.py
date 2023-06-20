from django.contrib import admin
from django.urls import path
from bookstore_app.views import user_login, user_logout, book_list, add_to_cart, cart


urlpatterns = [
    path('admin/', admin.site.urls),
    path('login/', user_login, name='login'),
    path('logout/', user_logout, name='logout'),
    path('books/', book_list, name='book_list'),
    path('cart/', cart, name='cart'),
    path('add_to_cart/<int:book_id>/', add_to_cart, name='add_to_cart'),
]
