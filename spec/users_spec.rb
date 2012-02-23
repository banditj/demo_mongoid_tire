require "spec_helper"

describe User do

  context "when users are created" do

    before do
      Tire.index 'users' do

        create
      end

      @good_user=User.create(snumber: 123, lname: "smith", fname: "john", age: 13, income: 123.12, username: "user1")
      @bad_user_with_strings= User.create(snumber: "123a", lname: "piss", fname: "hong", age: "oij", income: "oiw", username: "user2")
      @bad_user_with_wrong_commas= User.create(snumber: 1233, lname: "kiss", fname: "hong", age: 14, income: "123,23", username: "user3")

    end

    after do
      User.destroy_all
      Tire.index 'users' do
        delete
      end
    end

    it "should find all users without tire" do
      User.get_users().map(&:username).should eq(["user1", "user2", "user3"])
    end

    it "should find user1 via tire" do
      User.get_users("user1").map(&:username).should eq(["user1"])
    end

    it "should find user2 via tire" do
      User.get_users("user2").map(&:username).should eq(["user2"])
    end

    it "should find user3 via tire" do
      User.get_users("user3").map(&:username).should eq(["user3"])
    end
  end

end
