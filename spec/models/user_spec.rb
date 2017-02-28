require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user){ FactoryGirl.create(:user) }
    let(:user_with_history){ FactoryGirl.create(:user_with_history) }

  it "has factory make user with all" do
    
    user.comments << FactoryGirl.create(:comment, user_id: user.id)
    #user.likes << FactoryGirl.create(:like, user_id: user.id)
    expect(user.name).to eq("Testi Tauno")
    expect(user.email).to eq("testi@blaa.fi")
    expect(user.admin).to be false
    expect(user.moderator).to be false
    expect(user.title).to eq("opiskelija")
    expect(user.persistent_id).to eq("9876543")
    expect(user.comments).not_to be_empty
    #expect(user.likes).not_to be_empty
  end

  it "not created if duplicate persistent_id" do
    user20 = User.create name:"Test", persistent_id:"9876543"
    user30 = User.create name:"Test2", persistent_id:"9876543"    
    expect(User.count).to eq(1)
  end

  it "has history with basket New" do
    user_with_history.histories << FactoryGirl.create(:history)
    expect(user_with_history.histories.first.basket).to eq("New")
    expect(user_with_history.histories.count).to eq(1)

  end




  describe "without a name" do
    it "is not created" do
        user = User.new
        expect(user).not_to be_valid
    end
  end
end
