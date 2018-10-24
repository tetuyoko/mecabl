require 'csv'

def main
  Classifier.init

  filename = "./test/script/data.tsv"
  c = Classifier.load_classifier
  CSV.foreach(filename, col_sep: "\t") do |row|
    # [category, word_list]
    #p row[1].split(',').uniq.first(5).join(',')
    #p row[0], row[1].split(',').uniq.first(11).join(',')
    #c.train row[0], row[1].gsub!(/,/, " ")
    c.train row[0], row[1].split(',').uniq.first(11).join(',').gsub!(/,/, " ")
  end

  if Classifier.save_classifier(c) != 'OK'
    Rails.logger.error("cannot save classifier to redis: (#{_category})")
    Rails.logger.info("trained category: (#{_category})")
    return false
  end
end
