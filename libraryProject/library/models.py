# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models

# Create your models here.
# 1. table books
class Books(models.Model):
    # This is the primary key
    ISBN10 = models.CharField(max_length=30, primary_key = True)
    ISBN13 = models.IntegerField()
    Title = models.CharField(max_length=30)
    Authro = models.CharField(max_length=30)
    Cover = models.CharField(max_length=30)
    Publisher = models.CharField(max_length=30)
    Pages = models.IntegerField()
    
    # 2. table authors
class Authors(models.Model):
    # This is the primary key
    Author_id = models.IntegerField(max_length=30, primary_key=True)
    Name = models.CharField(max_length=30)
# 3. table book_authors
class Book_Authors(models.Model):
    # This is a primary key and foreign key
    Author_id = models.CharField(max_length=30, primary_key = True),
    # This is a foreign key
    ISBN10 = models.IntegerField()
# 4. table book_loans
class Book_Loans(models.Model):
    Loan_id = models.IntegerField(primary_key=True),
    Book_id = models.CharField(max_length=30),
    Card_No = models.CharField(max_length=30),
    Date_Out = models.DateField(),
    Date_In = models.DateField(),
    Due_Date = models.DateField()

# 5. table libray branch
class Library_Branch(models.Model):
    Branch_Id = models.IntegerField(primary_key=True),
    Branch_Name = models.CharField(max_length=30),
    Address = models.CharField(max_length = 30)


# 6. table borrowers
class Borrowers(models.Model):
    Card_No =models.CharField(max_length=30, primary_key=True),
    SSN =models.IntegerField(),
    First_Name  =models.CharField(max_length=30),
    Last_Name =models.CharField(max_length=30),
    Email =models.CharField(max_length=30),
    Address =models.CharField(max_length=30),
    City=models.CharField(max_length=30),
    Phone=models.IntegerField()

# 7. table book copies
class Book_Copies(models.Model):

# 8. table fines
class Fines(models.Model):
