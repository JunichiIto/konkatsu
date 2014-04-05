class LoveEachOther
  attr_reader :men, :women

  def initialize(text)
    @men, @women = text.each_line
      .map(&:strip)
      .map{|line| line.split(':')}
      .map{|name, names| [name, names.split(':')]}
      .map{|name, names| Person.new(name, *names)}
      .partition(&:man?)
  end

  def execute
    men.product(women)
      .map{|pair| Pair.new(*pair) }
      .select(&:any_possibility?)
      .sort_by(&:love_point)
      .group_by(&:man)
      .map(&:last)
      .map(&:first)
      .sort
      .join("\n")
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
      people.map(&:name).join("-")
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end

    private

    def people
      [man, woman]
    end

    def love_points
      people
        .permutation(2)
        .map{|person, other| person.how_much_love_this_person(other)}
    end
  end
end