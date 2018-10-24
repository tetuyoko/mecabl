# a = StatArray.new((1..10).to_a)
# => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
#
# a.min # Rubyの標準メソッド
# => 1
# a.max # Rubyの標準メソッド
# => 10
# a.sum
# => 55
# a.mean
# => 5.5
# a.var
# => 9.166666666666666
# a.sd
# => 3.0276503540974917
#
class StatArray < Array
  def sum
    reduce(:+)
  end

  def mean
    sum.to_f / size
  end

  def var
    m = mean
    reduce(0) { |a,b| a + (b - m) ** 2 } / (size - 1)
  end

  def sd
    Math.sqrt(var)
  end
end
