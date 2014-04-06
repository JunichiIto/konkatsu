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
      .map {|pair| pair.fix! if pair.both_no_partner?; pair }
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

    def you_got_partner!(partner)
      @partner = partner
    end

    def got_partner?
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
      @fixed = true
      man.you_got_partner!(woman)
      woman.you_got_partner!(man)
    end

    def both_no_partner?
      pair.none?(&:got_partner?)
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