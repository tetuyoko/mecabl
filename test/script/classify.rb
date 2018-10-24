require 'classifier-reborn'

def train
  categories = ['BL', 'アニメ', 'その他']
 # categories = "BL"
  classifier = ClassifierReborn::Bayes.new(categories, enable_threshold: true)
  classifier.train 'BL', "here are some good good words. I hoae you love them"
  classifier.train 'アニメ', "here are some bad words, I hate you"
  classifier.train 'その他', "unko"
  classifier_snapshot = Marshal.dump classifier
  File.open("./tmp/data/classifier.dat", "w") {|f| f.write(classifier_snapshot) }
  # Or Redis.current.save "classifier", classifier_snapshot
end

def classify
  # This is now saved to a file, and you can safely restart the
  data = File.read("./tmp/data/classifier.dat")
  # Or data = Redis.current.get "classifier"
  trained_classifier = Marshal.load data
  puts trained_classifier.classifications "I love" # returns 'Interesting'
  puts trained_classifier.classifications "hear" # returns 'Interesting'
  puts trained_classifier.classifications "hear are" # returns 'Interesting'
  puts trained_classifier.classifications "hear are" # returns 'Interesting'
end

def main
  train && classify
end
