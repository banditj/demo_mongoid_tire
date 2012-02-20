######
setup:

1) rake db:create_indexes
2) rake db:seed
3) rails c
   ---> User.import

################
Bug-Descriptions:

#BUG 1
using "," in number fields leads to untracked errors in elastic search.
so the new created document silently won't be indexed.

there are two problems:
1) the mongoid bug, which turns 123,23 into a string, which won't get parsed by elastic search
2) tire doesn't notice that the indexing of the document failed.

elasticsearch- error:
[2012-02-20 22:59:03,364][DEBUG][action.index             ] [Challenger] [users][4], node[TMv3RdfYR7GSTNmxTFKfmw], [P], s[STARTED]: Failed to execute [index {[users][user][4f42c1fec98969ee6f000008], source[{"_id":"4f42c1fec98969ee6f000008","age":23.23,"birthday":null,"birthday(1i)":"2012","birthday(2i)":"2","birthday(3i)":"20","fname":"eee","income":"23,23","lname":"eee","snumber":23.23,"username":"eee"}]}]
org.elasticsearch.index.mapper.MapperParsingException: Failed to parse [income]
        at org.elasticsearch.index.mapper.core.AbstractFieldMapper.parse(AbstractFieldMapper.java:309)
        at org.elasticsearch.index.mapper.object.ObjectMapper.serializeValue(ObjectMapper.java:577)
        at org.elasticsearch.index.mapper.object.ObjectMapper.parse(ObjectMapper.java:443)
        at org.elasticsearch.index.mapper.DocumentMapper.parse(DocumentMapper.java:465)
        at org.elasticsearch.index.mapper.DocumentMapper.parse(DocumentMapper.java:414)
        at org.elasticsearch.index.shard.service.InternalIndexShard.prepareIndex(InternalIndexShard.java:304)
        at org.elasticsearch.action.index.TransportIndexAction.shardOperationOnPrimary(TransportIndexAction.java:181)
        at org.elasticsearch.action.support.replication.TransportShardReplicationOperationAction$AsyncShardOperationAction.performOnPrimary(TransportShardReplicationOperationAction.java:487)
        at org.elasticsearch.action.support.replication.TransportShardReplicationOperationAction$AsyncShardOperationAction$1.run(TransportShardReplicationOperationAction.java:400)
        at java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:886)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:908)
        at java.lang.Thread.run(Thread.java:680)
Caused by: java.lang.NumberFormatException: For input string: "23,23"
        at sun.misc.FloatingDecimal.readJavaFormatString(FloatingDecimal.java:1222)
        at java.lang.Double.parseDouble(Double.java:510)
        at org.elasticsearch.common.xcontent.support.AbstractXContentParser.doubleValue(AbstractXContentParser.java:88)
        at org.elasticsearch.index.mapper.core.DoubleFieldMapper.parseCreateField(DoubleFieldMapper.java:231)
        at org.elasticsearch.index.mapper.core.AbstractFieldMapper.parse(AbstractFieldMapper.java:296)
        ... 11 more

#BUG 2
duplication error isn't rises when a user with the same "eee" username is being created
for mongoid it looks like the user got saved. 
AND tire does the indexing

###############
trigger errors:
1)create a user with username "eee"
and use the number which includes ","

2)create two users with the same username