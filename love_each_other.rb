class LoveEachOther
  attr_reader :men, :women

  def initialize(text)
    people = text.each_line.map do |line|
      name, names = line.strip.split(':')
      Person.new(name, names.split(','))
    end
    @men = people.select(&:man?)
    @women = people - men
  end

  def execute
    pairs = men.product(women).map {|pair| Pair.new(*pair) }
    ranked_pairs = pairs.select(&:any_possibility?).sort_by(&:love_point)
    fixed_pairs = men.map{|man| ranked_pairs.find{|pair| pair.man == man } }
    fixed_pairs.sort.join("\n")
  end

  class Person
    attr_reader :name

    def initialize(name, names_i_like)
      @name = name
      @names_i_like = names_i_like
    end

    def how_much_love_me(other)
      @names_i_like.index(other.name)
    end

    def man?
      name =~ /[A-Z]/
    end

    def ==(other)
      name == other.name
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
      love_points.inject(:+)
    end

    def any_possibility?
      !love_points.any?(&:nil?)
    end

    def to_s
      "#{man.name}-#{woman.name}"
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end

    private

    def love_points
      [man.how_much_love_me(woman), woman.how_much_love_me(man)]
    end
  end
end