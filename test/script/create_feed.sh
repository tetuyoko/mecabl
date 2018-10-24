#!/bin/sh

#
# jsonをjoで作成する
# %brew install jo 
# %jo -p object=$(jo title=いちあっぷ講座 url=https://ichi-up.net feed_url=https://ichi-up.net/feed description=いちあっぷ講座)
# 
#curl -H "Accept: application/json" -H "Content-type: application/json" -X POST  localhost:3000/feeds -d '{
#  "feed": {
#    "title": "いちあっぷ講座",
#    "url": "https://ichi-up.net",
#    "feed_url": "https://ichi-up.net/feed",
#    "description": "いちあっぷ講座"
#  }}'

curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST localhost:3000/feeds -d '
{
     "url": "https://ichi-up.net"
}'
