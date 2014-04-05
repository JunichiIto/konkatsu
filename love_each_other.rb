class LoveEachOther
  def self.choose_pairs(text)
    text.each_line
      .map(&:strip)
      .map{|line| line.split(":") }
      .map{|name, names| Person.new(name, names.split(",")) }
      .partition(&:man?)
      .each_slice(2)
      .flat_map{|men, women| men.product(women) }
      .map{|pair| Pair.new(*pair) }
      .select(&:any_possibility?)
      .sort_by(&:love_point)
      .group_by(&:man)
      .values
      .map(&:first)
      .sort
  end

  class Person
    attr_reader :name

    def initialize(name, names_i_like)
      @name, @names_i_like = name, names_i_like
    end

    def how_much_love_this_person(other)
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
      @man, @woman = man, woman
    end

    def love_point
      love_points.inject(:+)
    end

    def any_possibility?
      love_points.none?(&:nil?)
    end

    def to_s
      pair.map(&:name).join("-")
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end

    private

    def pair
      [man, woman]
    end

    def love_points
      pair
        .permutation(2)
        .map{|person, other| person.how_much_love_this_person(other) }
    end
  end
end