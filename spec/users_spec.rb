require "spec_helper"

describe User do

  context "mongoid integer or float field types" do
    before do
      @user_ok = User.new
    end

    it "should not set a string for age(integer) " do
      @user_ok.age = "asdf"
      @user_ok.should eq(nil)
    end

    it "should not set a float for age" do
      @user_ok.age = 12.12
      @user_ok.age.class.should eq(nil)
    end

    it "should set an Integer for age" do
      @user_ok.age = 12
      @user_ok.age.class.should eq(Fixnum)
    end
  end

  context "elastic search indexing via tire" do

    before do
      Tire.index 'users' do
        delete
        create
      end
      @good_user=User.create(snumber: 123, lname: "smith", fname: "john", age: 13, income: 123.12, username: "user1")
      @bad_user_with_strings= User.create(snumber: "123a", lname: "piss", fname: "hong", age: "oij", income: "oiw", username: "user2")
      @bad_user_with_wrong_commas= User.create(snumber: 1233, lname: "kiss", fname: "hong", age: 14, income: "123,23", username: "user3")
      sleep 1
    end

    after do
      User.destroy_all
      Tire.index 'users' do
        delete
      end
    end

    it "should find all users without tire" do
      User.get_users().map(&:username).should eq ["user1", "user2", "user3"]
    end

    it "should find user1 via tire" do
      #binding.pry
      User.get_users("user1").map(&:username).should eq ["user1"]
    end

    it "should find user2 via tire" do
      User.get_users("user2").map(&:username).should eq ["user2"]
    end

    it "should find user3 via tire" do
      User.get_users("user3").map(&:username).should eq ["user3"]
    end

    it "tire should not find any users after destroy_all" do
      User.destroy_all
      sleep 1
      Tire.search('users').count.should eq(0)
    end
  end
end
