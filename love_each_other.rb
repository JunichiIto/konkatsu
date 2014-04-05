class Person
  attr_reader :name

  def initialize(name, people_i_like)
    @name = name
    @people_i_like = people_i_like
  end

  def how_much_love_me(other)
    @people_i_like.index(other.name)
  end

  def to_s
    name
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
    @result = men.product(women).map do |man, woman|
      [[man.how_much_love_me(woman), woman.how_much_love_me(man)], [man, woman]]
    end
  end

  def rank
    @rank_result = @result.reject{|indicies, people| indicies.any?(&:nil?)}.sort_by{|indices, people| indices.inject(:+)}
  end

  def format_rank
    @men.map { |man|
      @rank_result.find{|_, people| people.first.name == man.name}
    }.map { |_, people| people.join('-') }.sort.join("\n")
  end
end