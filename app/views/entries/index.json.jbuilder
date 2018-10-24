json.array!(@entries) do |entry|
  json.extract! entry, :id, :feed_id, :title, :url, :author, :content, :category, :digest, :guid, :published_at, :version
  json.url entry_url(entry, format: :json)
end
