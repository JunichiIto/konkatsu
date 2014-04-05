class Person
  attr_reader :name

  def initialize(name, names_i_like)
    @name = name
    @names_i_like = names_i_like
  end

  def how_much_love_me(other)
    @names_i_like.index(other.name)
  end

  def to_s
    name
  end
end

class Pair
  attr_reader :man, :woman

  def initialize(man, woman)
    @man = man
    @woman = woman
  end

  def love_point
    raise "no possibility" unless any_possibility?
    man.how_much_love_me(@woman) + woman.how_much_love_me(@man)
  end

  def any_possibility?
    ![man.how_much_love_me(woman), woman.how_much_love_me(man)].any?(&:nil?)
  end

  def man_exists?(other_man)
    man.name == other_man.name
  end

  def to_s
    "#{man.name}-#{woman.name}"
  end

  def <=>(other)
    self.to_s <=> other.to_s
  end
end

class LoveEachOther
  attr_reader :men, :women

  def initialize(text)
    @men = []
    @women = []
    text.each_line do |line|
      name, names = line.strip.split(':')
      (name =~ /[A-Z]/ ? @men : @women) << Person.new(name, names.split(','))
    end
  end

  def execute
    pairs = men.product(women).map {|pair| Pair.new *pair}
    ranked_pairs = pairs.select(&:any_possibility?).sort_by(&:love_point)
    fixed_pairs = men.map{|man| ranked_pairs.find{|pair| pair.man_exists?(man) } }
    fixed_pairs.sort.join("\n")
  end
end