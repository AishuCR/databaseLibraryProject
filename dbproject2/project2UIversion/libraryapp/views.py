from django.shortcuts import render
from django.http import HttpResponse


# Create your views here.

def index(request):
   return HttpResponse('ths s a test page')
    # return render(request, 'index.html');