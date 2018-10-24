namespace :publisher do
  desc 'Publish to Fujossy'
  task post: :environment do
    unless response = Publisher.post!
      Rails.logger.info "No Entries."
      next
    end

    body = JSON.parse(response.body)

    unless response.success?
      Rails.logger.error "error: #{body["error"]}"
      next
    end

    success_entries = body["successes"]
    failure_entries = body["failures"]

    Rails.logger.info "成功: #{success_entries.size}件, 失敗: #{failure_entries.size}件"

    if failure_entries.present?
      failure_entries.each { |entry|
        Rails.logger.info "#{entry['url']}, #{entry['messages']}"
      }
    end
  end
end
