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

      %w(zigotto jtadeulopes).each do |username|
        it { score.users.map(&:twitter_screen_name).include?(username).should be_true }
      end

    end

  end

  describe Klout::User do

    describe "#topics" do
      pending
    end

    describe "#show" do

      context "provides information to many users" do

        use_vcr_cassette "show_usernames_zigotto_jtadeulopes_and_edercosta"

        let(:show) do
          @klout.show("zigotto,jtadeulopes,edercosta")
        end

        it { show.users.should have(3).users }

        %w(zigotto jtadeulopes edercosta).each do |username|
          it { show.users.map(&:twitter_screen_name).include?(username).should be_true }
        end

      end

      context "provides information about user" do

        use_vcr_cassette "show_username_zigotto"

        let(:show) do
          @klout.show("zigotto")
        end

        it { show.users.should have(1).users }
        it { show.users.first.twitter_id.should == "18770991" }
        it { show.users.first.twitter_screen_name.should == "zigotto" }

        let(:score) do
          show.users.first.score
        end

        it { score["kscore"].should == 25.98 }
        it { score["slope"].should == -0.11 }
        it { score["description"].should == "is influential to a tightly formed network that is growing larger" }
        it { score["kclass_id"].should == 4 }
        it { score["kclass"].should == "Explorer" }
        it { score["kclass_description"].should == "You actively engage in the social web, constantly trying out new ways to interact and network. You're exploring the ecosystem and making it work for you. Your level of activity and engagement shows that you \"get it\", we predict you'll be moving up." }
        it { score["kscore_description"].should == "is influential to a tightly formed network that is growing larger" }
        it { score["network_score"].should == 36.97 }
        it { score["amplification_score"].should == 12.71 }
        it { score["true_reach"].should == 80 }
        it { score["delta_1day"].should == 0.07 }
        it { score["delta_5day"].should == -0.07 }

      end

    end

  end

end
