require 'benchmark'
require 'classifier-reborn'

## benchmark
#
# 複雑なclassifierと単純なclassifierで分類処理性能が変わるかどうか試した
# →さして変わらない
#
# ruby classify_benchmark.rb
#  user     system      total        real
#  bayse:    0.000000   0.000000   0.000000 (0.000299)
#  simple_bayse:  0.000000   0.000000   0.000000 (0.000175)
#

def main
  n = 1
  Benchmark.bm(7) do |x|
    c = make_classifier
    x.report("bayse:") do 
      n.times { bayse(c) }
    end
    c = make_simple_classifier
    x.report("simple_bayse:") do
      n.times { simple_bayse(c) }
    end
  end
end

def make_classifier
  categories = ['BL', 'アニメ', 'その他']
  classifier = ClassifierReborn::Bayes.new(categories, enable_threshold: true)
  100000.times do |i|
    classifier.train 'BL', "#{i}here are some good good words. I hoae you love them"
    classifier.train 'アニメ', "here #{i}are some bad words, I hate you"
    classifier.train 'その他', "#{i}unko"
  end
  classifier_snapshot = Marshal.dump classifier
  File.open("./tmp/data/classifier.dat", "w") {|f| f.write(classifier_snapshot) }
  classifier
end

def make_simple_classifier
  categories = ['BL', 'アニメ', 'その他']
  c = ClassifierReborn::Bayes.new(categories, enable_threshold: true)
  c.train 'BL', "here are some good good words. I hoae you love them"
  c.train 'アニメ', "here are some bad words, I hate you"
  c.train 'その他', "unko"
  c
end

def bayse(c)
  c.classifications "I love" # returns 'Interesting'
  c.classifications "I love" # returns 'Interesting'
  c.classifications "hear" # returns 'Interesting'
  c.classifications "hear are" # returns 'Interesting'
  c.classifications "hear are" # returns 'Interesting'
end

#main
