# bin/rails r test/script/crawler.rb
def main
  url = "https://ichi-up.net/"
  #Feed.create_from_url(url)
  feed = Feed.find_by(url: url)
  c = Crawler.new(Logger.new(STDOUT))
  c.crawl(feed)
end
