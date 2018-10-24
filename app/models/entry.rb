# == Schema Information
#
# Table name: entries
#
#  id           :integer          not null, primary key
#  feed_id      :integer          default(0), not null
#  title        :text(65535)      not null
#  url          :string(255)      default(""), not null
#  author       :string(255)
#  content      :text(65535)
#  digest       :string(255)
#  guid         :string(255)
#  published_at :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  version      :integer          default(1), not null
#  tag_list     :text(65535)
#  category     :integer          default(0), not null
#  thumb_url    :string(255)
#

require 'natto'
require 'classifier'

class Entry < CategoryRecord
  belongs_to :feed
  before_save :set_taglist
  has_many :train_histories

  mount_uploader :image, ImageUploader

  SPECIAL_CARA_REG = /
                       ([^ぁ-んァ-ンーa-zA-Z0-9一-龠０-９\-\r]+) #特殊文字
                       |
                       (^\d{2,4}年$|\d{1,2}月$|\d{1,2}日$) #日付1
                     /xi
  BLACK_LIST = Settings.black_list_words
  TAG_LIMIT = 10

  def first_tag
    self.tag_list.split(",").first
  end

  def set_taglist
    return unless self.content
    title_text = self.title.try(:html2text)
    text = self.content.html2text
    natto =  if Rails.env.production?
               Natto::MeCab.new(dicdir: '/usr/lib/mecab/dic/mecab-ipadic-neologd')
             else
               Natto::MeCab.new
             end

    arr = []
    natto.parse("#{title_text} #{text}") do |n|
      if n.feature =~ /^名詞,[固有名詞]/
        unless (n.surface.size < 2 || n.surface =~ SPECIAL_CARA_REG || n.surface.in?(BLACK_LIST))
          arr << n.surface
        end
      end
    end
    arr.uniq!
    # 一文字を削除
    arr.delete_if {|word| !(word.bytesize > 2) }
    arr.sort_by!{|e| e.size }.reverse!
    self.tag_list = arr[0..TAG_LIMIT].join(",")

    recalc_category
  end

  def recalc_category
    self.category = Classifier.accure_classify(self.tag_list).try(:downcase)
    self
  end

  def pretty_category
    if category
      I18n.t('classifier.categories')[category.to_sym]
    end
  end

  def bl_score
    _tag_list =  self.tag_list || ""
    text = _tag_list.split(",").join(" ")
    Classifier.calc_bl_score(text)
  end
end
