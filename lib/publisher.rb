class Publisher
  # returns Faraday Request or false
  def self.post!
    time_before = Time.now.ago(Settings.publish_interval)
    entries = Entry.includes(:feed)
                   .where(Entry.arel_table[:updated_at].gt(time_before))

    unless entries.exists?
      return false
    end

    params = { articles: entries.map { |entry| entry_param(entry) } }
    http_connection.post Settings.media.article_create_path, params
  end

  private

  def self.http_connection
    fujossy = Rails.application.secrets.fujossy
    Faraday.new(url: Settings.media.url) do |faraday|
      faraday.request :json
      # faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.basic_auth fujossy["basic_auth_id"], fujossy["basic_auth_pw"]
    end
  end

  def self.entry_param(entry)
    {
      title: entry.title,
      url: entry.url,
      category: entry.pretty_category,
      thumb_url: entry.image_url,
      tag_list: entry.tag_list,
      body: entry.content,
      bl_score: entry.bl_score,
      media_name: entry.feed.title,
      published_at: entry.published_at,
    }
  end
end
