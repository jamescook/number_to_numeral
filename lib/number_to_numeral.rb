require "bundler/setup"
Bundler.require :default

class NumberToNumeral

  attr_reader :number, :cents, :phrase
  def initialize(data)
    sanitize(data.to_s)
    @phrase = nil
  end

  def groups
    { 1 => "hundred", 2 => "thousand", 3 => "million", 4 => "billion", 5 => "trillion"}.freeze
  end

  def tens
   {"twenty" => "2", "thirty" => "3", "forty" => "4", "fifty" => "5", "sixty" => "6", "seventy" => "7", "eighty" => "8",
    "ninety" => "9", "ten" => "1"}.invert.freeze
  end

  def teens
    {"ten" => "10", "eleven" => "11", "twelve" => "12", "thirteen" => "13", "fourteen" => "14", "fifteen" => "15", "sixteen" => "16",
     "seventeen" => "17", "eighteen" => "18", "nineteen" => "19"}.invert.freeze
  end

  def units
    {"one"  => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8",
     "nine" => "9"}.invert.freeze
  end

  def to_s
    process if phrase.nil?
    phrase
  end

  def inspect
    "<NumberToNumeral>"
  end

  def triplets_of number
    out = []
    number_split = number.split("").reverse # 1234 => [["234", "1"]]
    while number_split.any? do
      out << number_split.slice!(0, [3,number_split.size].min)
    end
    out.reverse.map{|o| o.reverse} # [ ["1"], ["234"] ]
  end

  def process
    triplets = triplets_of(number)
    @phrase  = []
    triplets.each_with_index do |triplet, i|
      group = groups[ triplets.size-i  ]
      if triplet.to_s.to_i == 0
        group = groups[ triplets.size ]
        unless group == @last_group #hackish?
          @phrase << group
        end
        next
      end
      @last_group = group

      if triplet.size == 1
        @phrase << units[ triplet.to_s ]
      end

      if triplet.size == 2
        if triplet[0..1].to_s.to_i.between?(1,9)
          @phrase << tens[ triplet.to_s]
        elsif triplet[0..1].to_s.to_i.between?(10, 19)
          @phrase << teens[ triplet[0..1].to_s]
        else #20+
          if triplet[1].to_s == "0"
            @phrase << (tens[ triplet[0].to_s]) # twenty, thirty
          else
            @phrase << (tens[ triplet[0].to_s] + "-" + units[ triplet[1].to_s]) # twenty-one, thirty-two
          end
        end
      end

      if triplet.size == 3
        unless triplet[0].to_s == "0"
          @phrase << units[ triplet[0].to_s] + " hundred"
        end

        unless triplet[1..2].to_s.to_i.zero?
          if triplet[2].to_s == "0"
            @phrase << tens[ triplet[1].to_s]
          else
            if triplet[1..2].to_s.to_i.between?(10, 19)
              @phrase << teens[ triplet[1..2].to_s]
            elsif triplet[1..2].to_s.to_i.between?(1, 9)
              @phrase << units[ triplet[1..2].to_s.to_i.to_s] # HAHHAHAHAHAHAHA take that leading zero
            else
              @phrase << (tens[ triplet[1].to_s] + "-" + units[ triplet[2].to_s] )
            end
          end
        end
      end
      if triplets[i+1]
        text = group
        if triplets[i+2]
         text << ","
        end

        @phrase << text
      elsif  triplets[i+1] && !triplets[i+2] && triplets.size > 2
        @phrase << group + " and"
      end
    end

    @phrase = @phrase.join(" ")
    append_cents_text
    phrase.strip
  end

  #TODO incomplete
  def append_cents_text
    if cents
      if cents.to_i.between? 0,9
        mode = :units
      end

      if cents.to_i.between? 10,19
        mode = :teens
      end

      if cents.to_i.between? 20,99
        mode = :tens
      end

      _cents = cents.split("")
      if mode == :units
        cents_to_word = units[_cents.last]
      end

      if mode == :teens
        cents_to_word = teens[_cents.to_s]
      end
      @phrase << " and #{cents_to_word} cents"
    end
  end

  protected
  def sanitize data
    @number, @cents = data.split(".")
    @number.gsub!(/[^\d]/, "")
    @number.gsub!(/\A0+/,'') # Leading zeros are evil
  end
end
