def main
  TrainHistory.tyu_tyu_train(1000)
end

def recalcing
  arr = []
  Entry.find_each do |e|
    begin
    arr << e.recalc_category
    rescue
    end
  end
  Entry.import arr, on_duplicate_key_update: [:id] 

  Entry.group(:category).count
end
