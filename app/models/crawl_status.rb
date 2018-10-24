# == Schema Information
#
# Table name: crawl_statuses
#
#  id              :integer          not null, primary key
#  feed_id         :integer          default(0), not null
#  status          :integer          default(1), not null
#  error_count     :integer          default(0), not null
#  error_message   :string(255)
#  http_status     :string(255)
#  digest          :string(255)
#  update_fequency :integer          default(0), not null
#  crawled_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CrawlStatus < ActiveRecord::Base
  belongs_to :feed

  scope :status_ok, ->{ where(status: Crawler::CRAWL_OK )}
  scope :expired, ->(ttl){
    where("crawled_at IS NULL OR crawled_at < ?", ttl.ago)
  }

  def self.fetch_crawlable_feed(options = {})
    CrawlStatus.where('crawled_at < ?', 30.minutes.ago).
      update_all(status: Crawler::CRAWL_OK)
    feed = nil

    CrawlStatus.transaction do
      if feed = Feed.crawlable.order("crawl_statuses.crawled_at").first
        feed.crawl_status.update_attributes(status: Crawler::CRAWL_NOW, crawled_at: Time.now)
      end
    end
    feed
  end

  private 
  # for debug
  def self.re_crawlable
    self.update_all crawled_at: nil, status: Crawler::CRAWL_OK
  end

end
