json.array!(@crawl_statuses) do |crawl_status|
  json.extract! crawl_status, :id, :feed_id, :status, :error_count, :error_message, :http_status, :digest, :update_fequency, :crawled_at
  json.url crawl_status_url(crawl_status, format: :json)
end
