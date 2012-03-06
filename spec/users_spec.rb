require "spec_helper"

describe User do

  context "mongoid integer or float field types" do
    before do
      @user_ok = User.new
    end

    it "should not set a string for age(integer) " do
      lambda {@user_ok.age = "asdf"}.should raise_error
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

    before(:all) do
      Tire.index 'users' do
        delete
        create
      end
      sleep 1
      @good_user=User.create(snumber: 123, lname: "smith", fname: "john", age: 13, income: 123.12, username: "user1")
      @bad_user_with_strings= User.create(snumber: "123a", lname: "piss", fname: "hong", age: "oij", income: "oiw", username: "user2")
      @bad_user_with_wrong_commas= User.create(snumber: 1233, lname: "kiss", fname: "hong", age: 14, income: "123,23", username: "user3")
    end

    after(:all) do
      User.destroy_all
      Tire.index 'users' do
        delete
      end
    end

    it "should find all users without tire" do
      sleep 1
      User.get_users().map(&:username).should eq ["user1", "user2", "user3"]
    end

    it "should find user1 via tire" do
      sleep 1
      User.get_users("user1").map(&:username).should eq ["user1"]

    end

    it "should find user2 via tire" do
      sleep 1
      User.get_users("user2").map(&:username).should eq ["user2"]
      # F because elasticsearch throughs an unnotice exception
      # see user 3
    end

    it "should find user3 via tire" do
      sleep 1
      User.get_users("user3").map(&:username).should eq ["user3"]
      # F because elasticsearch throughs an unnotice exception

      #[2012-03-06 18:37:37,339][DEBUG][action.index             ] [Fault Zone] [users][4], node[gtyr1NOFRqS111YOam8u5A], [P], s[STARTED]: Failed to execute [index {[users][user][4f564b61c989697481000006], source[{"_id":"4f564b61c989697481000006","age":14,"birthday":null,"fname":"hong","income":"123,23","lname":"kiss","snumber":1233,"username":"user3"}]}]
      #org.elasticsearch.index.mapper.MapperParsingException: Failed to parse [income]
      #        at org.elasticsearch.index.mapper.core.AbstractFieldMapper.parse(AbstractFieldMapper.java:308)
      #        at org.elasticsearch.index.mapper.object.ObjectMapper.serializeValue(ObjectMapper.java:577)
      #        at org.elasticsearch.index.mapper.object.ObjectMapper.parse(ObjectMapper.java:443)
      #        at org.elasticsearch.index.mapper.DocumentMapper.parse(DocumentMapper.java:475)
      #        at org.elasticsearch.index.mapper.DocumentMapper.parse(DocumentMapper.java:416)
      #        at org.elasticsearch.index.shard.service.InternalIndexShard.prepareIndex(InternalIndexShard.java:302)
      #        at org.elasticsearch.action.index.TransportIndexAction.shardOperationOnPrimary(TransportIndexAction.java:181)
      #        at org.elasticsearch.action.support.replication.TransportShardReplicationOperationAction$AsyncShardOperationAction.performOnPrimary(TransportShardReplicationOperationAction.java:487)
      #        at org.elasticsearch.action.support.replication.TransportShardReplicationOperationAction$AsyncShardOperationAction$1.run(TransportShardReplicationOperationAction.java:400)
      #        at java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:886)
      #        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:908)
      #        at java.lang.Thread.run(Thread.java:680)
      #Caused by: java.lang.NumberFormatException: For input string: "123,23"
      #        at sun.misc.FloatingDecimal.readJavaFormatString(FloatingDecimal.java:1222)
      #        at java.lang.Double.parseDouble(Double.java:510)
      #        at org.elasticsearch.common.xcontent.support.AbstractXContentParser.doubleValue(AbstractXContentParser.java:88)
      #        at org.elasticsearch.index.mapper.core.DoubleFieldMapper.parseCreateField(DoubleFieldMapper.java:231)
      #        at org.elasticsearch.index.mapper.core.AbstractFieldMapper.parse(AbstractFieldMapper.java:295)
      #        ... 11 more
    end

    it "tire should not find any users after destroy_all" do
      sleep 1
      User.destroy_all
      sleep 1
      Tire.search('users').count.should eq(0)
    end
  end
end
