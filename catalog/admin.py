from django.contrib import admin
from .models import User, Book

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    pass

@admin.register(Book)
class BookAdmin(admin.ModelAdmin):
    list_display = ('name', 'author', 'available', 'display_reserved_by')
    list_filter = ('available',)

    def display_reserved_by(self, obj):
        if obj.reserved_by:
            return obj.reserved_by.username
        return None

    display_reserved_by.short_description = 'Reserved By'
