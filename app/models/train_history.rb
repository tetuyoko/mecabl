# == Schema Information
#
# Table name: train_histories
#
#  id              :integer          not null, primary key
#  entry_id        :integer          not null
#  status          :integer          default(0), not null
#  category        :integer          default(0), not null
#  trained_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  train_master_id :integer
#

class TrainHistory < CategoryRecord
  belongs_to :entry
  belongs_to :train_master

  enum status: { default: 0, ok: 1, ng: 2 }

  scope :untrained_with_no_master, -> {
    untrained.
    where(train_master_id: nil)
  }

  scope :untrained, -> {
    includes(:entry).
    where(trained_at: nil).
    where("status != ?", statuses[:ok])
  }

  def normal_train
    if self.entry.tag_list.present? && Classifier.train_as(
                            self.category,
                            self.entry.tag_list.split(",").sample(5).join(",")
                          )
      self.dummy_train
    else
      self.trained_at = Time.current
      self.status = self.class.statuses["ng"]
    end
    self
  end

  def dummy_train
    self.trained_at = Time.current
    self.status = self.class.statuses["ok"]
    self
  end
end
