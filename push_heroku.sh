#!/bin/sh

git push heroku master

heroku run rake launch_worker -a ajxtechteam-crm
