from django.urls import path
  
# importing views from views.py
from . import views
  
urlpatterns = [
    path('', views.index, name='index' ),
]