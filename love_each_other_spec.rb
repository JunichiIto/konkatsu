require './love_each_other.rb'

describe LoveEachOther do
  let(:text) do
    <<-EOF.strip
A:c,b,a
B:a,b,d
C:a,c,b
D:d,a,c
a:A,C,D
b:D,A,B
c:B,A,C
d:D,C,A
    EOF
  end

  let(:answer) do
    <<-EOF.strip
A-c
B-b
C-a
D-d
    EOF
  end

  describe "#execute" do
    it 'returns valid result' do
      expect(LoveEachOther.new(text).execute).to eq answer
    end
  end
end