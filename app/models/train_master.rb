# == Schema Information
#
# Table name: train_masters
#
#  id           :integer          not null, primary key
#  mean         :integer          default(0), not null
#  content_json :text(65535)
#  trained_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'stat_array'

class TrainMaster < ActiveRecord::Base
  has_many :train_histories

  scope :untrained, -> {
    includes(:train_histories).
    where(trained_at: nil)
  }

  def content
    @content ||= JSON(content_json)
  end

  def train
    result = { ok: 0, ng: 0, opt_ok: 0, opt_ng: 0 }

    arr = []
    CategoryRecord.categories.each_pair do |k, v|
      # 偏りの平均化処理
      _diff = self.content["category_mean"][k]
      opt_counter = if (_diff != 0)
                      _diff.abs
                    else
                      0
                    end

      # 学習
      self.train_histories.where(category: v).find_each do |_th|
        if opt_counter > 0
          
          _method_name = (_diff < 0) ? :dummy_train : :normal_train
          if th = _th.__send__(_method_name)
            arr << th
            result[:opt_ok] += 1
          else
            result[:opt_ng] += 1
          end

          opt_counter -= 1
          next if _method_name == :dummy_train
        end

        if t = _th.normal_train
          arr << t
          result[:ok] += 1
        else
          result[:ng] += 1
        end
      end

    end

    TrainHistory.import arr, on_duplicate_key_update: [:id]
    self.trained_at = Time.current
    self.save!

    logger.info "**** count: #{result[:ok] + result[:ng]}"
    logger.info "**** ok: #{result[:ok]}"
    logger.info "**** ng: #{result[:ng]}"
  end

end
