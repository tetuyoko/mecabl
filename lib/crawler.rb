require 'feedbag'
require 'feedjira'
require 'addressable'
require 'logger'
require 'classifier'
require 'open_graph'

class Crawler
  ENTRIES_LIMIT = 500
  REDIRECT_LIMIT = 1
  GETA = [12307].pack("U")
  CRAWL_OK = 1
  CRAWL_NOW = 10

  def self.start(options = {})
    logger = options[:logger]

    unless logger
      target = options[:log_file] || STDOUT
      logger = Logger.new(target)
      logger.level = options[:log_level] || Logger::INFO
    end

    logger.warn '=> Booting Crawler...'
    self.new(logger).run
  end

  def initialize(logger)
    @logger = logger
  end

  def run
    @interval = 0

    finished = false
    until finished
      finished = run_loop
    end
  end

  def crawl(feed)
    result = {
      message: '',
      error: false,
      #response_code: nil,
    }
    REDIRECT_LIMIT.times do 
      begin
        @logger.info "fetch_and_parse: #{feed.feed_url}"
        parsed = Feedjira::Feed.fetch_and_parse(feed.feed_url)
        @logger.info "parsed: [#{parsed.entries.size} entries] #{parsed.feed_url}"
        ret = update(feed, parsed)
        result[:message] = "#{ret[:new_entries]} new entries, #{ret[:updated_entries]} updated entries"
      rescue => e
        result[:message] = "Error: #{e.message} #{e.backtrace.join('\n')}"
        result[:error] = true
        break
      end
    end
    result
  end

  private

  def run_loop
    begin
      run_body
    rescue Timeout::Error
      @logger.error "Time out: #{$!}"
    rescue Interrupt
      @logger.warn "\n=> #{$!.message} trapped. Terminating..."
      return true
    rescue Exception
      @logger.error %!Crawler error: #{$!.message}\n#{$!.backtrace.join("\n")}!
    ensure
      if @crawl_status
        @crawl_status.status = CRAWL_OK
        @crawl_status.save
      end
    end
    false
  end

  def run_body
    @logger.info "sleep: #{@interval}s"
    sleep @interval

    if feed = CrawlStatus.fetch_crawlable_feed
      @interval = 0

      result = crawl(feed)

      if result[:error]
        @logger.info "error: #{result[:message]}"
      else
        @crawl_status = feed.crawl_status
        #@crawl_status.http_status = result[:response_code]
        @logger.info "success: #{result[:message]}"
      end
    else
      @interval = @interval > 60 ? 60 : @interval + 1
    end
  end

  def update(feed, parsed)
    result = {
      new_entries: 0,
      updated_entries: 0,
      error: 0,
    }

    entries = parsed.entries.map do |entry|
      e = Entry.new(
          feed_id: feed.id,
          title: entry.title,
          url: entry.url || "",
          author: entry.author,
          content: fixup_relative_links(feed, entry.content || entry.summary),
          guid: entry.id,
          # 一旦1に決め打ち
          category: 1,
          digest: entry_digest(entry),
          published_at: entry.published ? entry.published.to_datetime : nil
        )
      e.remote_image_url = OpenGraph.fetch_image_or_blank(entry.url)
      e
    end

    entries = cut_off(entries)
    entries = reject_duplicated(feed, entries)
    delete_old_entries_if_new_entries_are_many(entries.size)
    update_or_insert_entries_to_feed(feed, entries, result)
    update_feed_information(feed, parsed)
    feed.save

    GC.start

    result
  end

  def fixup_relative_links(feed, body)
    doc = Nokogiri::HTML.fragment(body)
    links = doc.css('a[href]')
    if links.empty?
      body
    else
      links.each do |link|
        link['href'] = Addressable::URI.join(feed.feed_url, link['href']).normalize.to_s
      end
      doc.to_html
    end
  end

  def cut_off(entries)
    return entries unless entries.size > ENTRIES_LIMIT
    @logger.info "delete all entries: #{feed.feed_url}(#{feed.entries})"
    entries[0, ENTRIES_LIMIT]
  end

  def reject_duplicated(feed, entries)
    entries.uniq {|e| e.guid }.reject do |entry|
      feed.entries.exists?(guid: entry.guid, digest:  entry.digest)
    end
  end

  def delete_old_entries_if_new_entries_are_many(new_entries_size)
    return unless new_entries_size > ENTRIES_LIMIT / 2
    @logger.info "delete all entries: #{feed.feed_url}"
    Entry.where(feed_id: feed.id).delete_all
  end

  def update_or_insert_entries_to_feed(feed, entries, result)
    entries.reverse_each do |entry|
      if old_entry = feed.entries.find_by(guid: entry.guid)
        old_entry.increment(:version)
        unless almost_same(old_entry.title, entry.title) &&
          almost_same((old_entry.content || "").html2text, (entry.content || "").html2text)
          old_entry.published_at = entry.published_at
          result[:updated_entries] += 1
        end
        update_columns = %w(title url author content summary digest published_at)
        old_entry.attributes = entry.attributes.select{ |column, value| update_columns.include? column }
        old_entry.save
      else
        feed.entries << entry
        result[:new_entries] += 1
      end
    end
  end

  def update_feed_information(feed, parsed)
    feed.title = parsed.title
    feed.url = parsed.url
    feed.description = parsed.description || ""
  end

  def entry_digest(entry)
    str = "#{entry.title}#{entry.content}"
    str = str.gsub(%r{<br clear="all"\s*/>\s*<a href="http://rss\.rssad\.jp/(.*?)</a>\s*<br\s*/>}im, "")
    str = str.gsub(/\s+/, "")
    Digest::SHA1.hexdigest(str)
  end

  def almost_same(str1, str2)
    return true if (str1 == str2)
    chars1 = str1.split(//)
    chars2 = str2.split(//)
    return false if (chars1.length != chars2.length)
    # count differences
    [chars1, chars2].transpose.find_all { |pair|
      !pair.include?(GETA) && (pair[0] != pair[1])
    }.size <= 5
  end
end

