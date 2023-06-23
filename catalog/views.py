from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from .models import Book, User
from .data.data_mocker import DataMocker
from django.views.decorators.csrf import csrf_protect

mocker = DataMocker()
mocker.generate_mock_data()


def home(request):
    sort_by = request.GET.get('sort_by', 'name')  # Default sort by name
    books = Book.objects.all()

    if sort_by == 'name':
        books = books.order_by('name')
    elif sort_by == 'author':
        books = books.order_by('author')
    elif sort_by == 'availability':
        books = books.order_by('-available')

    return render(request, 'home.html', {'books': books, 'sort_by': sort_by})


@login_required
def reserve_book(request, book_id):
    book = Book.objects.get(id=book_id)
    if book.available:
        book.available = False
        book.reserved_by = request.user
        book.save()
    return redirect('home')


@login_required
def reserved_books(request):
    reserved_books = Book.objects.filter(reserved_by=request.user)
    return render(request, 'reserved_books.html', {'reserved_books': reserved_books})


@login_required
def unreserve_book(request, book_id):
    book = Book.objects.get(id=book_id)
    if book.reserved_by == request.user:
        book.available = True
        book.reserved_by = None
        book.save()
    return redirect('home')


@csrf_protect
def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')
        else:
            return render(request, 'login.html', {'message': 'Invalid credentials.'})
    return render(request, 'login.html')


def signup_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        User.objects.create_user(username=username, password=password)
        return redirect('login')
    return render(request, 'signup.html')


@login_required
def logout_view(request):
    logout(request)
    return redirect('home')
