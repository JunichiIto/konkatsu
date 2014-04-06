class Konkatsu
  def self.choose_pairs(text)
    text.each_line
      .map{|line| line.strip.split(":") }
      .map{|name, names| [name, (names ? names : "")]}
      .map{|name, names| Person.new(name, names.split(",")) }
      .partition(&:man?)
      .each_slice(2)
      .flat_map{|men, women| men.product(women) }
      .map{|pair| Pair.new(*pair) }
      .reject(&:no_possibility?)
      .sort_by(&:love_point)
      .each{|pair| pair.fix! if pair.both_single? }
      .select(&:fixed?)
      .sort
  end

  class Person
    attr_reader :name

    def initialize(name, names_i_like)
      @name, @names_i_like = name, names_i_like
      @partner = nil
    end

    def how_much_love_this_person(other)
      @names_i_like.index(other.name)
    end

    def relate!(partner)
      @partner = partner
    end

    def in_relationship?
      @partner
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
      @fixed = false
    end

    def love_point
      love_points.inject(:+)
    end

    def no_possibility?
      love_points.any?(&:nil?)
    end

    def fixed?
      @fixed
    end

    def fix!
      permutated_pair.each{|person, other| person.relate!(other) }
      @fixed = true
    end

    def both_single?
      pair.none?(&:in_relationship?)
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

    def permutated_pair
      pair.permutation(2)
    end

    def love_points
      permutated_pair.map{|person, other| person.how_much_love_this_person(other) }
    end
  end
end