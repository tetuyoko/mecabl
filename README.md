~~~
$ export CGO_LDFLAGS="`mecab-config --libs`"
$ export CGO_FLAGS="`mecab-config --inc-dir`"
~~~

## Run fastladder crawler process
~~~
$ bundle exec ruby script/crawler
~~~

### Run BackGround
~~~
$ bundle exec ruby script/crawler -d
~~~

## 学習の流れ
1. Feedを追加
1. CrawlerでEntryを収集
1. GUIでEntryを学習登録
1. Trainerで学習実行

## Feedを追加する
~~~
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST localhost:3000/feeds -d '
{
       "url": "https://ichi-up.net"
}'
~~~

## Entryを学習する
~~~
curl -F "category=funny" localhost:3000/entries/1684/train
~~~

## Classifierを初期化する
~~~
Classifier.init
~~~

## Trainerを実行する
~~~
Trainer.do
~~~

## URLをキーにimage_urlを取得する
~~~
[tetuyoko@tetuyoko-2 mecabl] % curl
"http://localhost:3000/new_image?url=https://ichi-up.net/hot2016/014"
{"thumb_url":"https://s3-ap-northeast-1.amazonaws.com/mecabl/development/image/aedc4bee0a02e9fd.png"}%
~~~
