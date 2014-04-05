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
    subject{ LoveEachOther.new(text).choose_pairs }
    it 'returns valid result' do
      expect(subject.join("\n")).to eq answer
    end
  end

  let(:text_2) do
    <<-EOF.strip
A:c,a,b
B:c,f,a
C:f,c,b
D:d,d,d
E:
F:e,c,a
a:A,D,F
b:C,B,A
c:D,A,C
d:A,A,B
e:C,A,E
f:D,B,A
    EOF
  end
end