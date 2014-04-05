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

  def to_s
    "#{man.name}-#{woman.name}"
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

  def self.execute(text)
    leo = LoveEachOther.new(text)
    leo.meet_each_other
    leo.rank
    leo.format_rank
  end

  def meet_each_other
    @pairs = men.product(women).map do |man, woman|
      Pair.new(man, woman)
    end
  end

  def rank
    @rank_result = @pairs.reject{|pair| !pair.any_possibility?}.sort_by{|pair| pair.love_point}
  end

  def format_rank
    @men.map { |man|
      @rank_result.find{|pair| pair.man.name == man.name}
    }.map { |pair| pair.to_s }.sort.join("\n")
  end
end