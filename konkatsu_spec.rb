require './konkatsu.rb'
require 'unindent'

describe Konkatsu do
  describe "#choose_pairs" do
    shared_examples "valid result" do
      it "returns valid result" do
        stripped_text, stripped_answer = [text, answer].map(&:unindent).map(&:strip)
        expect(Konkatsu.choose_pairs(stripped_text).join("\n")).to eq stripped_answer
      end
    end
    context "queston 1" do
      it_behaves_like "valid result" do
        let(:text) do
          <<-EOF
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
          <<-EOF
            A-c
            B-b
            C-a
            D-d
          EOF
        end
      end
    end
    context "question 2" do
      it_behaves_like "valid result" do
        let(:text) do
          <<-EOF
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
        let(:answer) do
          <<-EOF
            A-a
            B-f
            C-b
          EOF
        end
      end
    end
    context "question 3" do
      it_behaves_like "valid result" do
        let(:text) do
          <<-EOF
            A:d,b
            B:
            C:
            D:a,d,b
            a:
            b:
            c:
            d:C,D,A
          EOF
        end
        let(:answer) do
          <<-EOF
            D-d
          EOF
        end
      end
    end
  end
end