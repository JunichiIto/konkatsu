require './love_each_other.rb'

describe LoveEachOther do
  let(:text) do
    txt = <<EOF
A:c,b,a
B:a,b,d
C:a,c,b
D:d,a,c
a:A,C,D
b:D,A,B
c:B,A,C
d:D,C,A
EOF
    txt.strip
  end
  let(:answer) do
    ans = <<EOF
A-c
B-b
C-a
D-d
EOF
    ans.strip
  end
  describe '#initialize' do
    let(:leo) { LoveEachOther.new(text) }
    it 'men count' do
      expect(leo.men.count).to eq 4
    end
    it 'women count' do
      expect(leo.women.count).to eq 4
    end
  end
  describe "::execute" do
    it 'returns valid result' do
      expect(LoveEachOther.execute(text)).to eq answer
    end
  end
end