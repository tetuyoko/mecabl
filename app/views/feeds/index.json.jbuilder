json.array!(@feeds) do |feed|
  json.extract! feed, :id, :title, :url, :etag, :feed_url, :description, :modified_at
  json.url feed_url(feed, format: :json)
end
