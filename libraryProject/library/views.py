# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
]