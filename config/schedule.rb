# https://blog.hello-world.jp.net/ruby/3049/
require File.expand_path(File.dirname(__FILE__) + "/environment")

every Settings.publish_interval.seconds do
  rake "publisher:post"
end

# 月1で辞書ファイルをアップデートする
every '0 0 1 * *' do
  command "cd /home/ubuntu/mecab-ipadic-neologd && yes yes | ./bin/install-mecab-ipadic-neologd -n"
end

# 学習する
every '0 4 * * *' do
  rake "trainer:do"
end

every :day, at: '1:00am' do
  rake 'tmp_files:delete_uploads_tmp_files'
end
