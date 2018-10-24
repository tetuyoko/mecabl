def main
  entries = []
  Entry.all.find_each do |e|
    next if e.tag_list.blank?
    tags = e.tag_list.split(',')
    new_tags = []
    tags.each do |tag|
      if tag =~ /[^ぁ-んァ-ンーa-zA-Z0-9一-龠０-９\-\r]+/
        new_tags << tag
      end
    end
    next if new_tags.empty?
    e.tag_list = new_tags.join(",")
    entries << e
  end

  Entry.import entries, n_duplicate_key_update: [:id]

end
