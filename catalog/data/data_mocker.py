import random
from django.contrib.auth import get_user_model
from django.db import connection
from catalog.models import Book

class DataMocker:
    BOOK_TITLES = [
        'The Great Gatsby', 'To Kill a Mockingbird', '1984', 'Pride and Prejudice',
        'The Catcher in the Rye', 'Animal Farm', 'Brave New World', 'The Hobbit',
        'The Lord of the Rings', 'Fahrenheit 451', 'Jane Eyre', 'Moby-Dick',
        'The Odyssey', 'The Adventures of Huckleberry Finn', 'The Scarlet Letter',
        'Hamlet', 'The Iliad', 'Don Quixote', 'War and Peace', 'Alice\'s Adventures in Wonderland'
    ]

    def generate_mock_data(self):
        if self._should_generate_mock_data():
            self._generate_users()
            self._generate_books()

    def _should_generate_mock_data(self):
        User = get_user_model()
        user_table_exists = 'catalog_user' in connection.introspection.table_names()
        book_table_exists = 'catalog_book' in connection.introspection.table_names()

        if user_table_exists and book_table_exists:
            return not User.objects.exists() and not Book.objects.exists()

        return False

    def _generate_users(self):
        usernames = [
            'user1', 'user2', 'user3', 'user4', 'user5'
        ]
        for username in usernames:
            password = "password"
            User = get_user_model()
            User.objects.create_user(username=username, password=password)

    def _generate_books(self):
        for _ in range(50):
            title = random.choice(self.BOOK_TITLES)
            author = self._generate_random_author()
            available = random.choice([True, False])
            reserved_by = None

            if not available:
                User = get_user_model()
                users = User.objects.order_by('?')[:random.randint(1, 5)]
                reserved_by = random.choice(users)

            Book.objects.create(name=title, author=author, available=available, reserved_by=reserved_by)

    def _generate_random_author(self):
        first_names = ['John', 'Jane', 'Michael', 'Emily', 'Robert', 'Emma', 'David', 'Olivia', 'William', 'Sophia']
        last_names = ['Smith', 'Johnson', 'Brown', 'Miller', 'Jones', 'Davis', 'Garcia', 'Martinez', 'Clark', 'Lewis']
        return random.choice(first_names) + ' ' + random.choice(last_names)
