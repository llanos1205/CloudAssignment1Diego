from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from .models import Book, Cart


def user_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('book_list')
        else:
            error_message = 'Invalid username or password.'
            return render(request, 'login.html', {'error_message': error_message})
    return render(request, 'login.html')


@login_required
def user_logout(request):
    logout(request)
    return redirect('login')


@login_required
def book_list(request):
    books = Book.objects.all()

    # Retrieve the user's cart or None if it doesn't exist
    cart = request.user.cart if hasattr(request.user, 'cart') else None

    return render(request, 'book_list.html', {'books': books, 'cart': cart})


@login_required
def add_to_cart(request, book_id):
    book = Book.objects.get(pk=book_id)

    # Retrieve the user's cart or create a new one if it doesn't exist
    cart_id = request.session.get('cart_id')
    if cart_id:
        cart = Cart.objects.get(pk=cart_id)
    else:
        cart = Cart.objects.create()
        request.session['cart_id'] = cart.id

    # Add the book to the cart
    cart.books.add(book)

    return redirect('cart')


@login_required
def cart(request):
    # Retrieve the books in the cart for the current user
    cart_books = Book.objects.filter(cart__user=request.user)

    # Calculate the total cost
    total_cost = sum(book.price for book in cart_books)

    return render(request, 'cart.html', {'cart_books': cart_books, 'total_cost': total_cost})

