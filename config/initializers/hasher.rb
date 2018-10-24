module ClassifierReborn::Hasher
  def word_hash_for_words(words, language = 'en')
    d = Hash.new(0)
    words.each do |word|
      if word.bytesize > 2 && !STOPWORDS[language].include?(word)
        d[word.stem.intern] += 1
      end
    end
    return d
  end
end
