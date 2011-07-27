require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Klout do

  before do
    @klout = Klout::Client.new("wtg33wk54s6hjppr7y9sderj")
  end

  describe Klout::Score do

    context "when invalid username" do
      use_vcr_cassette "invalid_username"
      it { expect { @klout.score("alsdkfjlaskdfjlak") }.to raise_error(/404 Not Found/) }
    end

    context "provides score about a username" do

      use_vcr_cassette "username_zigotto"

      let(:score) do
        @klout.score("zigotto")
      end

      it { score.users.should have(1).users }
      it { score.users.first.kscore.should == 25.9 }
      it { score.users.first.twitter_screen_name.should == "zigotto" }

    end

    context "provides score to many usernames" do

      use_vcr_cassette "usernames_zigotto_and_jtadeulopes"

      let(:score) do
        @klout.score("zigotto,jtadeulopes")
      end

      it { score.users.should have(2).users }
      it { score.users.first.twitter_screen_name.should == "jtadeulopes" }
      it { score.users.first.kscore.should == 32.91 }

    end

  end

end
