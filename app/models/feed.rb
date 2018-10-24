# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  title       :text(65535)      not null
#  url         :string(255)      not null
#  etag        :string(255)
#  feed_url    :string(255)      not null
#  description :text(65535)      not null
#  modified_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Feed < ActiveRecord::Base
  extend TrailingSlash

  has_one :crawl_status
  has_many :entries

  scope :crawlable, -> {
    includes(:crawl_status).
      joins(:crawl_status).
      merge(CrawlStatus.status_ok).
      merge(CrawlStatus.expired(Settings.crawl_interval.minutes))
  }

  def self.create_from_url(url="")
    feed = initialize_from_url(url)
    self.transaction do
      feed.save
      feed.create_crawl_status
    end
    feed
  end

  def self.initialize_from_url(url="")
    feed_urls = Feedbag.find(url)
    if feed_urls.empty?
      fail "feed url not found: #{url}"
    end

    parsed = Feedjira::Feed.fetch_and_parse(feed_urls.first)

    self.new(
      title:       parsed.title,
      url:         trailing_slash(parsed.url),
      feed_url:    untrailing_slash(parsed.feed_url),
      etag:        parsed.etag,
      description: parsed.description || "",
      modified_at: parsed.last_modified || "",
    )
  end

  def crawl
  end
end
