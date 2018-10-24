require 'classifier-reborn'

class Classifier
  # エモートリアクション
  CATEGORIES = CategoryRecord.categories.keys
  THRESHOLD = -10.0
  REDIS_KEY= "classifier".freeze

  def self.init
    classifier = ClassifierReborn::Bayes.new(
                                              CATEGORIES, 
                                              enable_threshold: true,
                                              threshold: THRESHOLD
                                            )
    #train_dummy(classifier)
    save_classifier(classifier)
  end

  def self.train_as(category, words)
    _category = category.to_s

    return false unless is_valid?(category, words)

    words.gsub!(/,/, " ")

    c = load_classifier
    c.train(_category, words)

    if save_classifier(c) != 'OK'
      Rails.logger.error("cannot save classifier to redis: (#{_category})")
      Rails.logger.info("trained category: (#{_category})")
      return false
    end

    true
  end

  def self.train(category, text)
    classifier = load_classifier
    classifier.train category, text
    save_classifier(classifier)
  end

  def self.classify(text)
    classifier = load_classifier
    classifier.classify(text)
  end

  def self.classifications(text)
    classifier = load_classifier
    classifier.classifications(text)
  end

  def self.pretty_classifications(text)
    classifier = load_classifier
    h = classifier.classifications(text)
    new_hash = {}
    h.each do |k, v|
      key = I18n.t('classifier.categories')[k.downcase.to_sym ]
      new_hash[key] = v.round(2)
    end
    new_hash
  end

  def self.calc_bl_score(text)
    hash = self.pretty_classifications(text)
    ((hash["notBL"].abs - hash["BL"].abs) * 10).round
  end

  def self.pretty_classify(text)
    classifier = load_classifier
    h = classifier.classify_with_score(text)
    I18n.t('classifier.categories')[h[0].downcase.to_sym]
  end

  def self.accure_classify(text)
    classifier = load_classifier
    h = classifier.classify_with_score(text)
    h[0].downcase
  end

  def self.debug_show
    c = load_classifier
    c.inspect
  end

  private

  def self.is_valid?(category, words)
    if words.blank?
      Rails.logger.error("words blank")
      return false
    end

    unless category.in?(CATEGORIES)
      Rails.logger.error("invalid category: (#{category})")
      return false
    end

    true
  end

  def self.save_classifier(classifier)
    classifier_snapshot = Marshal.dump classifier
    Redis.current.set REDIS_KEY, classifier_snapshot
  end

  def self.load_classifier
    data = Redis.current.get REDIS_KEY
    Marshal.load(data)
  end

  def self.train_dummy(classifier)
    words = %w(ハッピーマン eigo マリオ ワリオ kurio ToLoveる hurindge)
    CATEGORIES.each do |c|
      classifier.train c, words.sample
    end
    classifier
  end

  def self.train_dummy_entry
    entry = Entry.first
    str = entry.tag_list
    str.gsub!(/,/, " ")
    c = load_classifier
    c.inspect
    c.train 'funny', str
    save_classifier(c)
  end
end

