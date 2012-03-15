require 'spec_helper.rb'

describe Redmine::Client do
  subject do
    Redmine::Client.new({
      :key    => "foo",
      :domain => "redmine.werbeboten.de",
      :debug  => true
    })
  end

  its(:protocol){ should == "http" }
  its(:domain){ should == "redmine.werbeboten.de" }
  its(:key){ should == "foo" }

  describe ".my_issues" do
    before(:all) do
      f = File.new("spec/stub/my_issues.atom")
      subject.stub(:open => f.read)
    end

    it{ subject.my_issues.should be_kind_of(Hash) }

    describe "result" do
      let(:result) do
        k = subject.my_issues.keys.first
        subject.my_issues[k]
      end

      it{ result.should be_kind_of(Array) }
      it{ result.first[:id].should be_kind_of(String) }
      it{ result.first[:title].should be_kind_of(String) }
    end
  end
end

