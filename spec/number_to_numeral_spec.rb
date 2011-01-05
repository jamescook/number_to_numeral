
describe NumberToNumeral do
  context "given '1,234'" do
    it "should convert to 'one thousand, two hundred thirty-four" do
      NumberToNumeral.new("1,234").to_s.should == "one thousand two hundred thirty-four"
    end
  end

  context "given '1'" do
    it "should convert to 'one'" do
      NumberToNumeral.new("1").to_s.should == "one"
    end
  end

  context "given '10'" do
    it "should convert to 'ten'" do
      NumberToNumeral.new("10").to_s.should == "ten"
    end
  end

  context "given '100'" do
    it "should convert to 'one hundred'" do
      NumberToNumeral.new("100").to_s.should == "one hundred"
    end
  end

  context "given '200'" do
    it "should convert to 'two hundred'" do
      NumberToNumeral.new("200").to_s.should == "two hundred"
    end
  end

  context "given '2,000'" do
    it "should convert to 'two thousand'" do
      NumberToNumeral.new("2000").to_s.should == "two thousand"
    end
  end

  context "given '2,001'" do
    it "should convert to 'two thousand one'" do
      NumberToNumeral.new("2001").to_s.should == "two thousand one"
    end
  end

  context "given '22,001'" do
    it "should convert to 'twenty-two thousand one'" do
      NumberToNumeral.new("22,001").to_s.should == "twenty-two thousand one"
    end
  end

  context "given '222,001'" do
    it "should convert to 'two hundred twenty-two thousand one'" do
      NumberToNumeral.new("222,001").to_s.should == "two hundred twenty-two thousand one"
    end
  end

  context "given '2,222,001'" do
    it "should convert to 'two million, two hundred twenty-two thousand one'" do
      NumberToNumeral.new("2,222,001").to_s.should == "two million, two hundred twenty-two thousand one"
    end
  end

  context "given '20,202,001'" do
    it "should convert to 'twenty million, two hundred two thousand one'" do
      NumberToNumeral.new("20,202,001").to_s.should == "twenty million, two hundred two thousand one"
    end
  end
end
