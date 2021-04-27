from django.db import models

# Create your models here.

#1.library branch table
class Project1LibraryBranch(models.Model):
    branch_id = models.BigIntegerField(primary_key=True)
    branch_name = models.CharField(max_length=100)
    address = models.CharField(max_length=128)

    class Meta:
        managed = False
        db_table = 'project1_library_branch'


class Project1LibraryBranchLoad(models.Model):
    branch_id = models.BigIntegerField(blank=True, null=True)
    branch_name = models.CharField(max_length=26, blank=True, null=True)
    address = models.CharField(max_length=128, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_library_branch_load'
#7.Book copies table
class Project1BookCopies(models.Model):
    book_id = models.BigAutoField(primary_key=True)
    branch = models.ForeignKey('Project1LibraryBranch', models.DO_NOTHING)
    isbn10 = models.ForeignKey('Project1Books', models.DO_NOTHING, db_column='isbn10')
    no_of_copies = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_book_copies'

#5.Book Loans table
class Project1BookLoans(models.Model):
    loan_id = models.BigAutoField(primary_key=True)
    book = models.ForeignKey(Project1BookCopies, models.DO_NOTHING)
    card_no = models.ForeignKey('Project1Borrowers', models.DO_NOTHING, db_column='card_no')
    date_out = models.DateField(blank=True, null=True)
    date_in = models.DateField(blank=True, null=True)
    due_date = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_book_loans'


#2.Fines table
class Project1Fines(models.Model):
    loan = models.OneToOneField(Project1BookLoans, models.DO_NOTHING, primary_key=True)
    fine_amt = models.BigIntegerField(blank=True, null=True)
    paid = models.CharField(max_length=28, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_fines'

class Project1BorrowersLoad(models.Model):
    id0000id = models.CharField(max_length=26, blank=True, null=True)
    ssn = models.CharField(max_length=26, blank=True, null=True)
    first_name = models.CharField(max_length=26, blank=True, null=True)
    last_name = models.CharField(max_length=26, blank=True, null=True)
    email = models.CharField(max_length=128, blank=True, null=True)
    address = models.CharField(max_length=128, blank=True, null=True)
    city = models.CharField(max_length=26, blank=True, null=True)
    state = models.CharField(max_length=26, blank=True, null=True)
    phone = models.CharField(max_length=26, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_borrowers_load'

#3.borrowers table
class Project1Borrowers(models.Model):
    card_no = models.CharField(primary_key=True, max_length=26)
    ssn = models.CharField(max_length=26, blank=True, null=True)
    first_name = models.CharField(max_length=26)
    last_name = models.CharField(max_length=26)
    email = models.CharField(max_length=128)
    address = models.CharField(max_length=128)
    city = models.CharField(max_length=26)
    state = models.CharField(max_length=26)
    phone = models.CharField(max_length=26, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_borrowers'

class Project1BooksTemptable(models.Model):
    temp_no = models.BigIntegerField()
    book_id = models.BigIntegerField()

    class Meta:
        managed = False
        db_table = 'project1_books_temptable'


class Project1BorrowerTemp(models.Model):
    temp_no = models.BigIntegerField()
    card_no = models.CharField(max_length=26)

    class Meta:
        managed = False
        db_table = 'project1_borrower_temp'

class Project1BooksLoad(models.Model):
    isbn10 = models.CharField(max_length=10, blank=True, null=True)
    isbn13 = models.BigIntegerField(blank=True, null=True)
    title = models.CharField(max_length=256, blank=True, null=True)
    authro = models.CharField(max_length=128, blank=True, null=True)
    cover = models.CharField(max_length=128, blank=True, null=True)
    publisher = models.CharField(max_length=128, blank=True, null=True)
    pages = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_books_load'

#4.Books table
class Project1Books(models.Model):
    isbn10 = models.CharField(primary_key=True, max_length=10)
    isbn13 = models.BigIntegerField(blank=True, null=True)
    title = models.CharField(max_length=256, blank=True, null=True)
    authro = models.CharField(max_length=128, blank=True, null=True)
    cover = models.CharField(max_length=128, blank=True, null=True)
    publisher = models.CharField(max_length=128, blank=True, null=True)
    pages = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_books'

class Project1BookCopiesLoad(models.Model):
    book_id = models.CharField(max_length=12, blank=True, null=True)
    branch_id = models.BigIntegerField(blank=True, null=True)
    no_of_copies = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_book_copies_load'

#8.authors table
class Project1Authors(models.Model):
    author_id = models.BigAutoField(primary_key=True)
    name = models.CharField(unique=True, max_length=128, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project1_authors'

#6.Book authors table
class Project1BookAuthors(models.Model):
    author = models.OneToOneField(Project1Authors, models.DO_NOTHING, primary_key=True)
    isbn10 = models.ForeignKey('Project1Books', models.DO_NOTHING, db_column='isbn10')

    class Meta:
        managed = False
        db_table = 'project1_book_authors'
        unique_together = (('author', 'isbn10'),)

