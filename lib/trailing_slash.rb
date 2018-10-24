module TrailingSlash
  def trailing_slash(original_url="")
    original_url.match(/\/$/) ? original_url : "#{original_url}/"
  end

  def untrailing_slash(original_url="")
    original_url.match(/\/$/) ? original_url[0..-2] : "#{original_url}"
  end
end
