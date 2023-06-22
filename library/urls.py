from django.contrib import admin
from django.urls import path, include
from catalog import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),
    path('reserve/<int:book_id>/', views.reserve_book, name='reserve_book'),
    path('unreserve/<int:book_id>/', views.unreserve_book, name='unreserve_book'),
    path('reserved/', views.reserved_books, name='reserved_books'),
    path('login/', views.login_view, name='login'),
    path('signup/', views.signup_view, name='signup'),
    path('logout/', views.logout_view, name='logout'),
   # path('accounts/', include('django.contrib.auth.urls')),
]
