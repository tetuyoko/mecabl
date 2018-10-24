require 'csv'

def main
  CSV.open("./test/script/data.tsv", "wb", col_sep: "\t") do |csv|
    CategoryRecord.categories.each_pair do |k,v|
      arr = TrainHistory.includes(:entry).
                        where('updated_at > ?', Time.current.yesterday).
                        where(category: v).map do |t|
                          t.entry.tag_list.split(',') 
                        end.flatten
      csv << [k, arr]
    end
  end

end

