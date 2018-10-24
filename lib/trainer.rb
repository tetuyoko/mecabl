require 'classifier'

class Trainer

  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end

  ## Trainを実行
  def self.do
    unless Trainer.calc_bunpu(wet_run: true)
      logger.info "**** no available history"
      return 
    end

    unless train_master = TrainMaster.untrained.last
      logger.info "**** no available train master"
      return 
    end

    train_master.train
  end

  # 前処理
  # Historyを集計して、平均値との差分をTrainMasterへ保存する
  def self.calc_bunpu(wet_run: false)
    sa = StatArray.new
    hash = {}

    text = "***** bunpu *****\n"
    text += "-----------------\n"

    _untraineds = TrainHistory.untrained_with_no_master
    if _untraineds.empty?
      text += "  no histories \n"
      text += "-----------------\n"
      puts text
      return false
    end
  
    CategoryRecord.categories.each_pair do |k, v|
      category_count = _untraineds.where(category: v).count
      hash[k] = category_count
      sa.push category_count 
      text += "#{k}: #{category_count}\n"
    end

    mean = sa.mean
    text += "***** mean *****\n"
    text += "sum: #{sa.sum}\n"
    text += "mean: #{mean.round(2)}\n"
    text += "sd: #{sa.sd.round(2)}\n"
    text += "var: #{sa.var.round(2)}\n"

    # 平均との差分を記録する
    # TODO: 0対応
    new_hash = {}
    hash.each_pair do |k,v|
      new_hash[k] = (mean - v).floor
    end
    puts new_hash

    _ha = {}
    _ha['category_mean'] = new_hash 

    puts text

    if wet_run
      ActiveRecord::Base.transaction do
        tm = TrainMaster.create!(mean: mean, content_json: _ha.to_json)
        _untraineds.update_all(train_master_id: tm.id)
      end
    end

    true
  end

  # create dummies
  def self.tyu_tyu_train(n=1000)
    arr = []

    n.times do
      entry = Entry.where( 'id >= ?', rand(Entry.first.id..Entry.last.id) ).first
      category = CategoryRecord.categories.values.sample
      arr << TrainHistory.new(entry_id: entry.id, category: category)
    end
    TrainHistory.import arr, on_duplicate_key_update: [:id]
  end

end
