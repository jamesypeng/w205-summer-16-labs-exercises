### Submit a PDF that includes your topology file based on Figure 1 (wordcount.clj) and a screenshot of your running application that shows the stream of tweet counts on screen.

#### wordcount.clj

```bash
(ns wordcount
  (:use     [streamparse.specs])
  (:gen-class))

(defn wordcount [options]
   [
    ;; spout configuration
    {
		"sentence-spout" (python-spout-spec
                ;; topology options passed in
                options
                ;; name of the python class to "run"
                "spouts.sentences.Sentences"
                ;; output specification, what named fields will this spout emit
                ["sentence"]
                ;;  two work threads
                :p 2
                )
    }
	
    {
		"Parse-1-bolt"   (python-bolt-spec 
                ;; topology options passed in
                options
                ;; inputs, where does this bolt receives its tuples from ?
                {"sentence-spout" :shuffle}
                ;; class to run 
                "bolts.parse.ParseTweet"
                ;; output spec, what tuples does this bolt emit
                ["word"]
                ;; configuration paramters
                :p 3
                )
		"Parse-2-bolt"   (python-bolt-spec 
                ;; topology options passed in
                options
                ;; inputs, where does this bolt receives its tuples from ?
                {"sentence-spout" :shuffle}
                ;; class to run 
                "bolts.parse.ParseTweet"
                ;; output spec, what tuples does this bolt emit
                ["word"]
                ;; configuration paramters
                :p 2
                )

		;; bolt configuration
		"TweetCounter-bolt" (python-bolt-spec
                options
                ;; inputs,
                {
				"Parse-1-bolt" ["word"]
				"Parse-2-bolt" ["word"]
				}
                ;; class to run 
                "bolts.tweetcounter.TweetCounter"
                ;; output spec, what tuples does this bolt emit
                ["word" "count"]
                :p 1
                )
    }
    ]
)
```
####  [run logs](https://raw.githubusercontent.com/jamesypeng/w205-summer-16-labs-exercises/master/lab_6/2016_07_03_sparse_run.log)

```{bash}

[root@ip-172-31-9-113 tweetcount]# sparse run
Running wordcount topology...
Routing Python logging to /root/tweetcount/logs.
Running lein command to run local cluster:
lein run -m streamparse.commands.run/-main topologies/wordcount.clj -t 0 --option 'topology.workers=2' --option 'topology.acker.executors=2' --option 'streamparse.log.path="/root/tweetcount/logs"' --option 'streamparse.log.level="debug"'
WARNING: You're currently running as root; probably by accident.
Press control-C to abort or Enter to continue as root.
Set LEIN_ROOT to disable this warning.

3425 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:zookeeper.version=3.4.6-1569965, built on 02/20/2014 09:09 GMT
3441 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:host.name=ip-172-31-9-113.ec2.internal
3441 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.version=1.7.0_79
3441 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.vendor=Oracle Corporation
3441 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.home=/opt/jdk1.7.0_79/jre
3441 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.class.path=/root/tweetcount/test:/root/tweetcount/topologies:/root/tweetcount/dev-resources:/root/tweetcount/_resources:/root/tweetcount/_build/classes:/root/.m2/repository/ch/qos/logback/logback-classic/1.0.13/logback-classic-1.0.13.jar:/root/.m2/repository/org/clojure/tools.macro/0.1.0/tools.macro-0.1.0.jar:/root/.m2/repository/ring/ring-core/1.1.5/ring-core-1.1.5.jar:/root/.m2/repository/hiccup/hiccup/0.3.6/hiccup-0.3.6.jar:/root/.m2/repository/ring/ring-servlet/0.3.11/ring-servlet-0.3.11.jar:/root/.m2/repository/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar:/root/.m2/repository/org/clojure/math.numeric-tower/0.0.1/math.numeric-tower-0.0.1.jar:/root/.m2/repository/clj-time/clj-time/0.4.1/clj-time-0.4.1.jar:/root/.m2/repository/org/objenesis/objenesis/1.2/objenesis-1.2.jar:/root/.m2/repository/com/twitter/chill-java/0.3.5/chill-java-0.3.5.jar:/root/.m2/repository/com/parsely/streamparse/0.0.4-SNAPSHOT/streamparse-0.0.4-SNAPSHOT.jar:/root/.m2/repository/ring/ring-jetty-adapter/0.3.11/ring-jetty-adapter-0.3.11.jar:/root/.m2/repository/jline/jline/2.11/jline-2.11.jar:/root/.m2/repository/clj-stacktrace/clj-stacktrace/0.2.2/clj-stacktrace-0.2.2.jar:/root/.m2/repository/org/clojure/tools.nrepl/0.2.12/tools.nrepl-0.2.12.jar:/root/.m2/repository/org/slf4j/slf4j-api/1.7.5/slf4j-api-1.7.5.jar:/root/.m2/repository/ring/ring-devel/0.3.11/ring-devel-0.3.11.jar:/root/.m2/repository/org/mortbay/jetty/jetty-util/6.1.26/jetty-util-6.1.26.jar:/root/.m2/repository/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar:/root/.m2/repository/clojure-complete/clojure-complete/0.2.4/clojure-complete-0.2.4.jar:/root/.m2/repository/org/yaml/snakeyaml/1.11/snakeyaml-1.11.jar:/root/.m2/repository/ch/qos/logback/logback-core/1.0.13/logback-core-1.0.13.jar:/root/.m2/repository/commons-lang/commons-lang/2.5/commons-lang-2.5.jar:/root/.m2/repository/org/mortbay/jetty/jetty/6.1.26/jetty-6.1.26.jar:/root/.m2/repository/joda-time/joda-time/2.0/joda-time-2.0.jar:/root/.m2/repository/commons-io/commons-io/2.4/commons-io-2.4.jar:/root/.m2/repository/commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar:/root/.m2/repository/com/esotericsoftware/kryo/kryo/2.21/kryo-2.21.jar:/root/.m2/repository/com/esotericsoftware/minlog/minlog/1.2/minlog-1.2.jar:/root/.m2/repository/org/apache/storm/storm-core/0.9.5/storm-core-0.9.5.jar:/root/.m2/repository/compojure/compojure/1.1.3/compojure-1.1.3.jar:/root/.m2/repository/com/esotericsoftware/reflectasm/reflectasm/1.07/reflectasm-1.07-shaded.jar:/root/.m2/repository/com/twitter/carbonite/1.4.0/carbonite-1.4.0.jar:/root/.m2/repository/commons-codec/commons-codec/1.6/commons-codec-1.6.jar:/root/.m2/repository/commons-fileupload/commons-fileupload/1.2.1/commons-fileupload-1.2.1.jar:/root/.m2/repository/org/clojure/data.json/0.2.6/data.json-0.2.6.jar:/root/.m2/repository/org/slf4j/log4j-over-slf4j/1.6.6/log4j-over-slf4j-1.6.6.jar:/root/.m2/repository/org/jgrapht/jgrapht-core/0.9.0/jgrapht-core-0.9.0.jar:/root/.m2/repository/org/clojure/clojure/1.5.1/clojure-1.5.1.jar:/root/.m2/repository/org/clojure/tools.logging/0.2.3/tools.logging-0.2.3.jar:/root/.m2/repository/org/ow2/asm/asm/4.0/asm-4.0.jar:/root/.m2/repository/clout/clout/1.0.1/clout-1.0.1.jar:/root/.m2/repository/org/apache/commons/commons-exec/1.1/commons-exec-1.1.jar:/root/.m2/repository/com/googlecode/disruptor/disruptor/2.10.1/disruptor-2.10.1.jar:/root/.m2/repository/org/clojure/core.incubator/0.1.0/core.incubator-0.1.0.jar:/root/.m2/repository/org/clojure/tools.cli/0.2.4/tools.cli-0.2.4.jar
3442 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
3442 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.io.tmpdir=/tmp
3442 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:java.compiler=<NA>
3442 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:os.name=Linux
3442 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:os.arch=amd64
3442 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:os.version=2.6.32-573.7.1.el6.centos.plus.x86_64
3443 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:user.name=root
3443 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:user.home=/root
3443 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Client environment:user.dir=/root/tweetcount
3490 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:zookeeper.version=3.4.6-1569965, built on 02/20/2014 09:09 GMT
3490 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:host.name=ip-172-31-9-113.ec2.internal
3490 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.version=1.7.0_79
3490 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.vendor=Oracle Corporation
3491 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.home=/opt/jdk1.7.0_79/jre
3491 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.class.path=/root/tweetcount/test:/root/tweetcount/topologies:/root/tweetcount/dev-resources:/root/tweetcount/_resources:/root/tweetcount/_build/classes:/root/.m2/repository/ch/qos/logback/logback-classic/1.0.13/logback-classic-1.0.13.jar:/root/.m2/repository/org/clojure/tools.macro/0.1.0/tools.macro-0.1.0.jar:/root/.m2/repository/ring/ring-core/1.1.5/ring-core-1.1.5.jar:/root/.m2/repository/hiccup/hiccup/0.3.6/hiccup-0.3.6.jar:/root/.m2/repository/ring/ring-servlet/0.3.11/ring-servlet-0.3.11.jar:/root/.m2/repository/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar:/root/.m2/repository/org/clojure/math.numeric-tower/0.0.1/math.numeric-tower-0.0.1.jar:/root/.m2/repository/clj-time/clj-time/0.4.1/clj-time-0.4.1.jar:/root/.m2/repository/org/objenesis/objenesis/1.2/objenesis-1.2.jar:/root/.m2/repository/com/twitter/chill-java/0.3.5/chill-java-0.3.5.jar:/root/.m2/repository/com/parsely/streamparse/0.0.4-SNAPSHOT/streamparse-0.0.4-SNAPSHOT.jar:/root/.m2/repository/ring/ring-jetty-adapter/0.3.11/ring-jetty-adapter-0.3.11.jar:/root/.m2/repository/jline/jline/2.11/jline-2.11.jar:/root/.m2/repository/clj-stacktrace/clj-stacktrace/0.2.2/clj-stacktrace-0.2.2.jar:/root/.m2/repository/org/clojure/tools.nrepl/0.2.12/tools.nrepl-0.2.12.jar:/root/.m2/repository/org/slf4j/slf4j-api/1.7.5/slf4j-api-1.7.5.jar:/root/.m2/repository/ring/ring-devel/0.3.11/ring-devel-0.3.11.jar:/root/.m2/repository/org/mortbay/jetty/jetty-util/6.1.26/jetty-util-6.1.26.jar:/root/.m2/repository/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar:/root/.m2/repository/clojure-complete/clojure-complete/0.2.4/clojure-complete-0.2.4.jar:/root/.m2/repository/org/yaml/snakeyaml/1.11/snakeyaml-1.11.jar:/root/.m2/repository/ch/qos/logback/logback-core/1.0.13/logback-core-1.0.13.jar:/root/.m2/repository/commons-lang/commons-lang/2.5/commons-lang-2.5.jar:/root/.m2/repository/org/mortbay/jetty/jetty/6.1.26/jetty-6.1.26.jar:/root/.m2/repository/joda-time/joda-time/2.0/joda-time-2.0.jar:/root/.m2/repository/commons-io/commons-io/2.4/commons-io-2.4.jar:/root/.m2/repository/commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar:/root/.m2/repository/com/esotericsoftware/kryo/kryo/2.21/kryo-2.21.jar:/root/.m2/repository/com/esotericsoftware/minlog/minlog/1.2/minlog-1.2.jar:/root/.m2/repository/org/apache/storm/storm-core/0.9.5/storm-core-0.9.5.jar:/root/.m2/repository/compojure/compojure/1.1.3/compojure-1.1.3.jar:/root/.m2/repository/com/esotericsoftware/reflectasm/reflectasm/1.07/reflectasm-1.07-shaded.jar:/root/.m2/repository/com/twitter/carbonite/1.4.0/carbonite-1.4.0.jar:/root/.m2/repository/commons-codec/commons-codec/1.6/commons-codec-1.6.jar:/root/.m2/repository/commons-fileupload/commons-fileupload/1.2.1/commons-fileupload-1.2.1.jar:/root/.m2/repository/org/clojure/data.json/0.2.6/data.json-0.2.6.jar:/root/.m2/repository/org/slf4j/log4j-over-slf4j/1.6.6/log4j-over-slf4j-1.6.6.jar:/root/.m2/repository/org/jgrapht/jgrapht-core/0.9.0/jgrapht-core-0.9.0.jar:/root/.m2/repository/org/clojure/clojure/1.5.1/clojure-1.5.1.jar:/root/.m2/repository/org/clojure/tools.logging/0.2.3/tools.logging-0.2.3.jar:/root/.m2/repository/org/ow2/asm/asm/4.0/asm-4.0.jar:/root/.m2/repository/clout/clout/1.0.1/clout-1.0.1.jar:/root/.m2/repository/org/apache/commons/commons-exec/1.1/commons-exec-1.1.jar:/root/.m2/repository/com/googlecode/disruptor/disruptor/2.10.1/disruptor-2.10.1.jar:/root/.m2/repository/org/clojure/core.incubator/0.1.0/core.incubator-0.1.0.jar:/root/.m2/repository/org/clojure/tools.cli/0.2.4/tools.cli-0.2.4.jar
3491 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
3491 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.io.tmpdir=/tmp
3491 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:java.compiler=<NA>
3492 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:os.name=Linux
3492 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:os.arch=amd64
3492 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:os.version=2.6.32-573.7.1.el6.centos.plus.x86_64
3492 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:user.name=root
3492 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:user.home=/root
3492 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Server environment:user.dir=/root/tweetcount
5420 [main] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Created server with tickTime 2000 minSessionTimeout 4000 maxSessionTimeout 40000 datadir /tmp/fd80d876-5e29-4e94-b670-d527ab5fe58a/version-2 snapdir /tmp/fd80d876-5e29-4e94-b670-d527ab5fe58a/version-2
5440 [main] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - binding to port 0.0.0.0/0.0.0.0:2000
5456 [main] INFO  backtype.storm.zookeeper - Starting inprocess zookeeper at port 2000 and dir /tmp/fd80d876-5e29-4e94-b670-d527ab5fe58a
6005 [main] INFO  backtype.storm.daemon.nimbus - Starting Nimbus with conf {"dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/bf4be1ae-6b4c-4568-b18a-4432c9bd4e69", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" nil, "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" nil, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" [6700 6701 6702 6703], "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.message.timeout.secs" 30, "task.refresh.poll.secs" 10, "topology.workers" 1, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil}
6012 [main] INFO  backtype.storm.daemon.nimbus - Using default scheduler
6031 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
6294 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
6298 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@57803780
6335 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
6348 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58671
6351 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
6371 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58671
6374 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.persistence.FileTxnLog - Creating new log file: log.1
6389 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970000, negotiated timeout = 20000
6398 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970000 with negotiated timeout 20000 for client /127.0.0.1:58671
6400 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
6403 [main-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
7466 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef970000
7468 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef970000 closed
7470 [main-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
7471 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58671 which had sessionid 0x155ae5cef970000
7472 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
7472 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
7473 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@7980a595
7485 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
7485 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
7486 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58672
7486 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58672
7489 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970001 with negotiated timeout 20000 for client /127.0.0.1:58672
7490 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970001, negotiated timeout = 20000
7490 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
7566 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
7567 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
7567 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@5e69cd5e
7569 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
7569 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58673
7569 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
7570 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58673
7581 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970002 with negotiated timeout 20000 for client /127.0.0.1:58673
7583 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970002, negotiated timeout = 20000
7584 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
7584 [main-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
7587 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef970002
7588 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef970002 closed
7588 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
7589 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
7603 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58673 which had sessionid 0x155ae5cef970002
7598 [main-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
7604 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@18b44ce0
7605 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
7605 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58674
7606 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
7606 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58674
7607 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
7608 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
7608 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@71e910bd
7617 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
7618 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58675
7618 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
7619 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58675
7634 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970003 with negotiated timeout 20000 for client /127.0.0.1:58674
7634 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970003, negotiated timeout = 20000
7634 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
7636 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970004 with negotiated timeout 20000 for client /127.0.0.1:58675
7636 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970004, negotiated timeout = 20000
7636 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
7636 [main-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
7638 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef970004
7639 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef970004 closed
7639 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
7640 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
7640 [main-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
7642 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@6acce1af
7643 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
7644 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
7654 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58675 which had sessionid 0x155ae5cef970004
7654 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58676
7655 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58676
7657 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970005 with negotiated timeout 20000 for client /127.0.0.1:58676
7657 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970005, negotiated timeout = 20000
7658 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
7707 [main] INFO  backtype.storm.daemon.supervisor - Starting Supervisor with conf {"dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/63b02899-6033-4e68-a95d-cec9803bd21d", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" nil, "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" nil, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" (1024 1025 1026), "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.message.timeout.secs" 30, "task.refresh.poll.secs" 10, "topology.workers" 1, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil}
7725 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
7726 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
7726 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@716f6c5b
7729 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
7729 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58677
7730 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
7730 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58677
7733 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970006 with negotiated timeout 20000 for client /127.0.0.1:58677
7733 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970006, negotiated timeout = 20000
7733 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
7734 [main-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
8736 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef970006
8738 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef970006 closed
8738 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
8739 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
8739 [main-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
8739 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58677 which had sessionid 0x155ae5cef970006
8740 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@4220f21b
8741 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
8741 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58678
8742 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
8744 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58678
8757 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970007 with negotiated timeout 20000 for client /127.0.0.1:58678
8757 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970007, negotiated timeout = 20000
8757 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
8800 [main] INFO  backtype.storm.daemon.supervisor - Starting supervisor with id a56b4a29-a5fb-49aa-bef8-611b57e3bd8b at host ip-172-31-9-113.ec2.internal
8817 [main] INFO  backtype.storm.daemon.supervisor - Starting Supervisor with conf {"dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/183bf74d-628a-46f1-ba2e-d8bc3f3aa600", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" nil, "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" nil, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" (1027 1028 1029), "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.message.timeout.secs" 30, "task.refresh.poll.secs" 10, "topology.workers" 1, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil}
8819 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
8820 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
8820 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@227ed534
8829 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
8830 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58679
8830 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
8831 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58679
8832 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970008 with negotiated timeout 20000 for client /127.0.0.1:58679
8833 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970008, negotiated timeout = 20000
8834 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
8834 [main-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
9839 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef970008
9841 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58679 which had sessionid 0x155ae5cef970008
9841 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef970008 closed
9842 [main] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
9842 [main] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
9842 [main-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
9848 [main] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@1e28a31b
9858 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
9859 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58680
9859 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
9859 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58680
9862 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef970009 with negotiated timeout 20000 for client /127.0.0.1:58680
9863 [main-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef970009, negotiated timeout = 20000
9863 [main-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
10873 [main] INFO  backtype.storm.daemon.supervisor - Starting supervisor with id 9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd at host ip-172-31-9-113.ec2.internal
11020 [main] INFO  backtype.storm.daemon.nimbus - Received topology submission for wordcount with conf {"storm.id" "wordcount-1-1467509179", "topology.acker.executors" 2, "streamparse.log.path" "/root/tweetcount/logs", "topology.kryo.decorators" (), "topology.name" "wordcount", "topology.max.spout.pending" 5000, "topology.debug" false, "topology.kryo.register" nil, "topology.message.timeout.secs" 60, "topology.workers" 2, "topology.max.task.parallelism" nil, "streamparse.log.level" "debug"}
11119 [main] INFO  backtype.storm.daemon.nimbus - Activating wordcount: wordcount-1-1467509179
11387 [main] INFO  backtype.storm.scheduler.EvenScheduler - Available slots: (["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1024] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1025] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1026] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1027] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1028] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1029])
11639 [main] INFO  backtype.storm.daemon.nimbus - Setting new assignment for topology id wordcount-1-1467509179: #backtype.storm.daemon.common.Assignment{:master-code-dir "/tmp/bf4be1ae-6b4c-4568-b18a-4432c9bd4e69/nimbus/stormdist/wordcount-1-1467509179", :node->host {"a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" "ip-172-31-9-113.ec2.internal", "9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" "ip-172-31-9-113.ec2.internal"}, :executor->node+port {[2 2] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1027], [3 3] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1024], [4 4] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1027], [5 5] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1024], [6 6] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1027], [7 7] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1024], [8 8] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1027], [9 9] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1024], [10 10] ["9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd" 1027], [1 1] ["a56b4a29-a5fb-49aa-bef8-611b57e3bd8b" 1024]}, :executor->start-time-secs {[2 2] 1467509180, [3 3] 1467509180, [4 4] 1467509180, [5 5] 1467509180, [6 6] 1467509180, [7 7] 1467509180, [8 8] 1467509180, [9 9] 1467509180, [10 10] 1467509180, [1 1] 1467509180}}
13226 [Thread-3] INFO  backtype.storm.daemon.supervisor - Copying resources at file:/root/tweetcount/_resources/resources to /tmp/63b02899-6033-4e68-a95d-cec9803bd21d/supervisor/stormdist/wordcount-1-1467509179/resources
13243 [Thread-5] INFO  backtype.storm.daemon.supervisor - Copying resources at file:/root/tweetcount/_resources/resources to /tmp/183bf74d-628a-46f1-ba2e-d8bc3f3aa600/supervisor/stormdist/wordcount-1-1467509179/resources
13416 [Thread-6] INFO  backtype.storm.daemon.supervisor - Launching worker with assignment #backtype.storm.daemon.supervisor.LocalAssignment{:storm-id "wordcount-1-1467509179", :executors ([2 2] [4 4] [6 6] [8 8] [10 10])} for this supervisor 9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd on port 1027 with id 44f8b128-3c3d-4a72-bcbf-b3acfee0ef26
13418 [Thread-6] INFO  backtype.storm.daemon.worker - Launching worker for wordcount-1-1467509179 on 9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd:1027 with id 44f8b128-3c3d-4a72-bcbf-b3acfee0ef26 and conf {"dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/183bf74d-628a-46f1-ba2e-d8bc3f3aa600", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" nil, "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" nil, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" (1027 1028 1029), "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.message.timeout.secs" 30, "task.refresh.poll.secs" 10, "topology.workers" 1, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil}
13419 [Thread-6] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
13428 [Thread-4] INFO  backtype.storm.daemon.supervisor - Launching worker with assignment #backtype.storm.daemon.supervisor.LocalAssignment{:storm-id "wordcount-1-1467509179", :executors ([3 3] [5 5] [7 7] [9 9] [1 1])} for this supervisor a56b4a29-a5fb-49aa-bef8-611b57e3bd8b on port 1024 with id 2fecfbc6-0391-4113-a411-275bcf6166df
13465 [Thread-4] INFO  backtype.storm.daemon.worker - Launching worker for wordcount-1-1467509179 on a56b4a29-a5fb-49aa-bef8-611b57e3bd8b:1024 with id 2fecfbc6-0391-4113-a411-275bcf6166df and conf {"dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/63b02899-6033-4e68-a95d-cec9803bd21d", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" nil, "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" nil, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" (1024 1025 1026), "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.message.timeout.secs" 30, "task.refresh.poll.secs" 10, "topology.workers" 1, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil}
13465 [Thread-4] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
13465 [Thread-4] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
13466 [Thread-4] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@4a28a15f
13467 [Thread-4-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
13467 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58682
13467 [Thread-4-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
13468 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58682
13470 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef97000a with negotiated timeout 20000 for client /127.0.0.1:58682
13471 [Thread-4-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef97000a, negotiated timeout = 20000
13471 [Thread-4-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
13480 [Thread-6] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
13481 [Thread-6] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000 sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@4c8f1195
13482 [Thread-6-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
13482 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58683
13482 [Thread-6-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
13483 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58683
13484 [Thread-4-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
13488 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef97000b with negotiated timeout 20000 for client /127.0.0.1:58683
13488 [Thread-6-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef97000b, negotiated timeout = 20000
13517 [Thread-6-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
13517 [Thread-6-EventThread] INFO  backtype.storm.zookeeper - Zookeeper state update: :connected:none
13519 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef97000b
13520 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58683 which had sessionid 0x155ae5cef97000b
13521 [Thread-6] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef97000b closed
13522 [Thread-6] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
13522 [Thread-6] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
13522 [Thread-6-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
13523 [Thread-6] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@572ea885
13524 [Thread-6-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
13525 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58684
13525 [Thread-6-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
13525 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58684
13528 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef97000c with negotiated timeout 20000 for client /127.0.0.1:58684
13539 [Thread-6-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef97000c, negotiated timeout = 20000
13539 [Thread-6-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
14482 [ProcessThread(sid:0 cport:-1):] INFO  org.apache.storm.zookeeper.server.PrepRequestProcessor - Processed session termination for sessionid: 0x155ae5cef97000a
14484 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxn - Closed socket connection for client /127.0.0.1:58682 which had sessionid 0x155ae5cef97000a
14485 [Thread-4] INFO  org.apache.storm.zookeeper.ZooKeeper - Session: 0x155ae5cef97000a closed
14485 [Thread-4] INFO  backtype.storm.utils.StormBoundedExponentialBackoffRetry - The baseSleepTimeMs [1000] the maxSleepTimeMs [30000] the maxRetries [5]
14485 [Thread-4] INFO  org.apache.storm.curator.framework.imps.CuratorFrameworkImpl - Starting
14485 [Thread-4-EventThread] INFO  org.apache.storm.zookeeper.ClientCnxn - EventThread shut down
14486 [Thread-4] INFO  org.apache.storm.zookeeper.ZooKeeper - Initiating client connection, connectString=localhost:2000/storm sessionTimeout=20000 watcher=org.apache.storm.curator.ConnectionState@665db0a0
14487 [Thread-4-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Opening socket connection to server localhost/127.0.0.1:2000. Will not attempt to authenticate using SASL (unknown error)
14487 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.NIOServerCnxnFactory - Accepted socket connection from /127.0.0.1:58685
14487 [Thread-4-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Socket connection established to localhost/127.0.0.1:2000, initiating session
14488 [NIOServerCxn.Factory:0.0.0.0/0.0.0.0:2000] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Client attempting to establish new session at /127.0.0.1:58685
14491 [SyncThread:0] INFO  org.apache.storm.zookeeper.server.ZooKeeperServer - Established session 0x155ae5cef97000d with negotiated timeout 20000 for client /127.0.0.1:58685
14491 [Thread-4-SendThread(localhost:2000)] INFO  org.apache.storm.zookeeper.ClientCnxn - Session establishment complete on server localhost/127.0.0.1:2000, sessionid = 0x155ae5cef97000d, negotiated timeout = 20000
14491 [Thread-4-EventThread] INFO  org.apache.storm.curator.framework.state.ConnectionStateManager - State change: CONNECTED
14547 [Thread-6] INFO  backtype.storm.daemon.worker - Reading Assignments.
14682 [Thread-6] INFO  backtype.storm.daemon.worker - Launching receive-thread for 9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd:1027
14700 [Thread-7-worker-receiver-thread-0] INFO  backtype.storm.messaging.loader - Starting receive-thread: [stormId: wordcount-1-1467509179, port: 1027, thread-id: 0 ]
15546 [Thread-4] INFO  backtype.storm.daemon.worker - Reading Assignments.
15573 [Thread-6] INFO  backtype.storm.daemon.executor - Loading executor Parse-1-bolt:[2 2]
15595 [Thread-6] INFO  backtype.storm.daemon.executor - Loaded executor tasks Parse-1-bolt:[2 2]
15611 [refresh-active-timer] INFO  backtype.storm.daemon.worker - All connections are ready for worker 9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd:1027 with id 44f8b128-3c3d-4a72-bcbf-b3acfee0ef26
15679 [Thread-6] INFO  backtype.storm.daemon.executor - Finished loading executor Parse-1-bolt:[2 2]
15699 [Thread-6] INFO  backtype.storm.daemon.executor - Loading executor Parse-2-bolt:[4 4]
15715 [Thread-4] INFO  backtype.storm.daemon.worker - Launching receive-thread for a56b4a29-a5fb-49aa-bef8-611b57e3bd8b:1024
15717 [Thread-6] INFO  backtype.storm.daemon.executor - Loaded executor tasks Parse-2-bolt:[4 4]
15737 [Thread-10-worker-receiver-thread-0] INFO  backtype.storm.messaging.loader - Starting receive-thread: [stormId: wordcount-1-1467509179, port: 1024, thread-id: 0 ]
15757 [Thread-6] INFO  backtype.storm.daemon.executor - Finished loading executor Parse-2-bolt:[4 4]
15790 [Thread-6] INFO  backtype.storm.daemon.executor - Loading executor TweetCounter-bolt:[6 6]
15806 [Thread-4] INFO  backtype.storm.daemon.executor - Loading executor Parse-1-bolt:[3 3]
15796 [Thread-6] INFO  backtype.storm.daemon.executor - Loaded executor tasks TweetCounter-bolt:[6 6]
15812 [Thread-4] INFO  backtype.storm.daemon.executor - Loaded executor tasks Parse-1-bolt:[3 3]
15822 [Thread-6] INFO  backtype.storm.daemon.executor - Finished loading executor TweetCounter-bolt:[6 6]
15847 [Thread-6] INFO  backtype.storm.daemon.executor - Loading executor __acker:[8 8]
15848 [Thread-6] INFO  backtype.storm.daemon.executor - Loaded executor tasks __acker:[8 8]
15850 [Thread-4] INFO  backtype.storm.daemon.executor - Finished loading executor Parse-1-bolt:[3 3]
15863 [Thread-6] INFO  backtype.storm.daemon.executor - Timeouts disabled for executor __acker:[8 8]
15864 [Thread-6] INFO  backtype.storm.daemon.executor - Finished loading executor __acker:[8 8]
15913 [Thread-4] INFO  backtype.storm.daemon.executor - Loading executor Parse-2-bolt:[5 5]
15934 [Thread-4] INFO  backtype.storm.daemon.executor - Loaded executor tasks Parse-2-bolt:[5 5]
15951 [Thread-6] INFO  backtype.storm.daemon.executor - Loading executor sentence-spout:[10 10]
15961 [Thread-4] INFO  backtype.storm.daemon.executor - Finished loading executor Parse-2-bolt:[5 5]
15982 [Thread-6] INFO  backtype.storm.daemon.executor - Loaded executor tasks sentence-spout:[10 10]
15999 [Thread-4] INFO  backtype.storm.daemon.executor - Loading executor __acker:[7 7]
16000 [Thread-4] INFO  backtype.storm.daemon.executor - Loaded executor tasks __acker:[7 7]
16003 [Thread-4] INFO  backtype.storm.daemon.executor - Timeouts disabled for executor __acker:[7 7]
16004 [Thread-4] INFO  backtype.storm.daemon.executor - Finished loading executor __acker:[7 7]
16016 [Thread-6] INFO  backtype.storm.daemon.executor - Finished loading executor sentence-spout:[10 10]
16033 [Thread-4] INFO  backtype.storm.daemon.executor - Loading executor sentence-spout:[9 9]
16035 [Thread-4] INFO  backtype.storm.daemon.executor - Loaded executor tasks sentence-spout:[9 9]
16040 [Thread-6] INFO  backtype.storm.daemon.executor - Loading executor __system:[-1 -1]
16050 [Thread-4] INFO  backtype.storm.daemon.executor - Finished loading executor sentence-spout:[9 9]
16056 [Thread-4] INFO  backtype.storm.daemon.executor - Loading executor __system:[-1 -1]
16056 [Thread-4] INFO  backtype.storm.daemon.executor - Loaded executor tasks __system:[-1 -1]
16066 [Thread-6] INFO  backtype.storm.daemon.executor - Loaded executor tasks __system:[-1 -1]
16068 [Thread-6] INFO  backtype.storm.daemon.executor - Finished loading executor __system:[-1 -1]
16082 [Thread-4] INFO  backtype.storm.daemon.executor - Finished loading executor __system:[-1 -1]
16089 [Thread-4] INFO  backtype.storm.daemon.executor - Loading executor Parse-1-bolt:[1 1]
16102 [Thread-4] INFO  backtype.storm.daemon.executor - Loaded executor tasks Parse-1-bolt:[1 1]
16115 [Thread-4] INFO  backtype.storm.daemon.executor - Finished loading executor Parse-1-bolt:[1 1]
16116 [Thread-4] INFO  backtype.storm.daemon.worker - Worker has topology config {"storm.id" "wordcount-1-1467509179", "dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/63b02899-6033-4e68-a95d-cec9803bd21d", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" 2, "streamparse.log.path" "/root/tweetcount/logs", "topology.kryo.decorators" (), "topology.name" "wordcount", "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" 5000, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" (1024 1025 1026), "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.kryo.register" nil, "topology.message.timeout.secs" 60, "task.refresh.poll.secs" 10, "topology.workers" 2, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil, "streamparse.log.level" "debug"}
16119 [Thread-4] INFO  backtype.storm.daemon.worker - Worker 2fecfbc6-0391-4113-a411-275bcf6166df for storm wordcount-1-1467509179 on a56b4a29-a5fb-49aa-bef8-611b57e3bd8b:1024 has finished loading
16135 [Thread-6] INFO  backtype.storm.daemon.worker - Worker has topology config {"storm.id" "wordcount-1-1467509179", "dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.tick.tuple.freq.secs" nil, "topology.builtin.metrics.bucket.size.secs" 60, "topology.fall.back.on.java.serialization" true, "topology.max.error.report.per.interval" 5, "zmq.linger.millis" 0, "topology.skip.missing.kryo.registrations" true, "storm.messaging.netty.client_worker_threads" 1, "ui.childopts" "-Xmx768m", "storm.zookeeper.session.timeout" 20000, "nimbus.reassign" true, "topology.trident.batch.emit.interval.millis" 50, "storm.messaging.netty.flush.check.interval.ms" 10, "nimbus.monitor.freq.secs" 10, "logviewer.childopts" "-Xmx128m", "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib", "topology.executor.send.buffer.size" 1024, "storm.local.dir" "/tmp/183bf74d-628a-46f1-ba2e-d8bc3f3aa600", "storm.messaging.netty.buffer_size" 5242880, "supervisor.worker.start.timeout.secs" 120, "topology.enable.message.timeouts" true, "nimbus.cleanup.inbox.freq.secs" 600, "nimbus.inbox.jar.expiration.secs" 3600, "drpc.worker.threads" 64, "storm.meta.serialization.delegate" "backtype.storm.serialization.DefaultSerializationDelegate", "topology.worker.shared.thread.pool.size" 4, "nimbus.host" "localhost", "storm.messaging.netty.min_wait_ms" 100, "storm.zookeeper.port" 2000, "transactional.zookeeper.port" nil, "topology.executor.receive.buffer.size" 1024, "transactional.zookeeper.servers" nil, "storm.zookeeper.root" "/storm", "storm.zookeeper.retry.intervalceiling.millis" 30000, "supervisor.enable" true, "storm.messaging.netty.server_worker_threads" 1, "storm.zookeeper.servers" ["localhost"], "transactional.zookeeper.root" "/transactional", "topology.acker.executors" 2, "streamparse.log.path" "/root/tweetcount/logs", "topology.kryo.decorators" (), "topology.name" "wordcount", "topology.transfer.buffer.size" 1024, "topology.worker.childopts" nil, "drpc.queue.size" 128, "worker.childopts" "-Xmx768m", "supervisor.heartbeat.frequency.secs" 5, "topology.error.throttle.interval.secs" 10, "zmq.hwm" 0, "drpc.port" 3772, "supervisor.monitor.frequency.secs" 3, "drpc.childopts" "-Xmx768m", "topology.receiver.buffer.size" 8, "task.heartbeat.frequency.secs" 3, "topology.tasks" nil, "storm.messaging.netty.max_retries" 300, "topology.spout.wait.strategy" "backtype.storm.spout.SleepSpoutWaitStrategy", "nimbus.thrift.max_buffer_size" 1048576, "topology.max.spout.pending" 5000, "storm.zookeeper.retry.interval" 1000, "topology.sleep.spout.wait.strategy.time.ms" 1, "nimbus.topology.validator" "backtype.storm.nimbus.DefaultTopologyValidator", "supervisor.slots.ports" (1027 1028 1029), "topology.environment" nil, "topology.debug" false, "nimbus.task.launch.secs" 120, "nimbus.supervisor.timeout.secs" 60, "topology.kryo.register" nil, "topology.message.timeout.secs" 60, "task.refresh.poll.secs" 10, "topology.workers" 2, "supervisor.childopts" "-Xmx256m", "nimbus.thrift.port" 6627, "topology.stats.sample.rate" 0.05, "worker.heartbeat.frequency.secs" 1, "topology.tuple.serializer" "backtype.storm.serialization.types.ListDelegateSerializer", "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "topology.multilang.serializer" "backtype.storm.multilang.JsonSerializer", "nimbus.task.timeout.secs" 30, "storm.zookeeper.connection.timeout" 15000, "topology.kryo.factory" "backtype.storm.serialization.DefaultKryoFactory", "drpc.invocations.port" 3773, "logviewer.port" 8000, "zmq.threads" 1, "storm.zookeeper.retry.times" 5, "topology.worker.receiver.thread.count" 1, "storm.thrift.transport" "backtype.storm.security.auth.SimpleTransportPlugin", "topology.state.synchronization.timeout.secs" 60, "supervisor.worker.timeout.secs" 30, "nimbus.file.copy.expiration.secs" 600, "storm.messaging.transport" "backtype.storm.messaging.netty.Context", "logviewer.appender.name" "A1", "storm.messaging.netty.max_wait_ms" 1000, "drpc.request.timeout.secs" 600, "storm.local.mode.zmq" false, "ui.port" 8080, "nimbus.childopts" "-Xmx1024m", "storm.cluster.mode" "local", "topology.max.task.parallelism" nil, "storm.messaging.netty.transfer.batch.size" 262144, "topology.classpath" nil, "streamparse.log.level" "debug"}
16135 [Thread-6] INFO  backtype.storm.daemon.worker - Worker 44f8b128-3c3d-4a72-bcbf-b3acfee0ef26 for storm wordcount-1-1467509179 on 9e1cae14-b705-4f4f-bf1f-17e6d5d15ccd:1027 has finished loading
16646 [refresh-active-timer] INFO  backtype.storm.daemon.worker - All connections are ready for worker a56b4a29-a5fb-49aa-bef8-611b57e3bd8b:1024 with id 2fecfbc6-0391-4113-a411-275bcf6166df
17028 [Thread-23-__acker] INFO  backtype.storm.daemon.executor - Preparing bolt __acker:(7)
17029 [Thread-24-sentence-spout] INFO  backtype.storm.daemon.executor - Opening spout sentence-spout:(10)
17030 [Thread-14-TweetCounter-bolt] INFO  backtype.storm.daemon.executor - Preparing bolt TweetCounter-bolt:(6)
17030 [Thread-31-__system] INFO  backtype.storm.daemon.executor - Preparing bolt __system:(-1)
17030 [Thread-28-__system] INFO  backtype.storm.daemon.executor - Preparing bolt __system:(-1)
17030 [Thread-16-Parse-1-bolt] INFO  backtype.storm.daemon.executor - Preparing bolt Parse-1-bolt:(3)
17031 [Thread-33-Parse-1-bolt] INFO  backtype.storm.daemon.executor - Preparing bolt Parse-1-bolt:(1)
17031 [Thread-26-sentence-spout] INFO  backtype.storm.daemon.executor - Opening spout sentence-spout:(9)
17033 [Thread-9-Parse-1-bolt] INFO  backtype.storm.daemon.executor - Preparing bolt Parse-1-bolt:(2)
17033 [Thread-20-Parse-2-bolt] INFO  backtype.storm.daemon.executor - Preparing bolt Parse-2-bolt:(5)
17033 [Thread-12-Parse-2-bolt] INFO  backtype.storm.daemon.executor - Preparing bolt Parse-2-bolt:(4)
17083 [Thread-31-__system] INFO  backtype.storm.daemon.executor - Prepared bolt __system:(-1)
17084 [Thread-18-__acker] INFO  backtype.storm.daemon.executor - Preparing bolt __acker:(8)
17095 [Thread-18-__acker] INFO  backtype.storm.daemon.executor - Prepared bolt __acker:(8)
17086 [Thread-23-__acker] INFO  backtype.storm.daemon.executor - Prepared bolt __acker:(7)
17133 [Thread-24-sentence-spout] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17134 [Thread-28-__system] INFO  backtype.storm.daemon.executor - Prepared bolt __system:(-1)
17137 [Thread-9-Parse-1-bolt] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17137 [Thread-20-Parse-2-bolt] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17138 [Thread-12-Parse-2-bolt] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17138 [Thread-14-TweetCounter-bolt] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17138 [Thread-26-sentence-spout] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17138 [Thread-16-Parse-1-bolt] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
17138 [Thread-33-Parse-1-bolt] INFO  backtype.storm.utils.ShellProcess - Storm multilang serializer: backtype.storm.multilang.JsonSerializer
18424 [Thread-20-Parse-2-bolt] INFO  backtype.storm.task.ShellBolt - Launched subprocess with pid 13481
18438 [Thread-33-Parse-1-bolt] INFO  backtype.storm.task.ShellBolt - Launched subprocess with pid 13486
18485 [Thread-33-Parse-1-bolt] INFO  backtype.storm.task.ShellBolt - Start checking heartbeat...
18485 [Thread-33-Parse-1-bolt] INFO  backtype.storm.daemon.executor - Prepared bolt Parse-1-bolt:(1)
18488 [Thread-20-Parse-2-bolt] INFO  backtype.storm.task.ShellBolt - Start checking heartbeat...
18488 [Thread-20-Parse-2-bolt] INFO  backtype.storm.daemon.executor - Prepared bolt Parse-2-bolt:(5)
18863 [Thread-9-Parse-1-bolt] INFO  backtype.storm.task.ShellBolt - Launched subprocess with pid 13480
18881 [Thread-9-Parse-1-bolt] INFO  backtype.storm.task.ShellBolt - Start checking heartbeat...
18881 [Thread-9-Parse-1-bolt] INFO  backtype.storm.daemon.executor - Prepared bolt Parse-1-bolt:(2)
18881 [Thread-24-sentence-spout] INFO  backtype.storm.spout.ShellSpout - Launched subprocess with pid 13479
18890 [Thread-14-TweetCounter-bolt] INFO  backtype.storm.task.ShellBolt - Launched subprocess with pid 13483
18894 [Thread-16-Parse-1-bolt] INFO  backtype.storm.task.ShellBolt - Launched subprocess with pid 13485
18900 [Thread-14-TweetCounter-bolt] INFO  backtype.storm.task.ShellBolt - Start checking heartbeat...
18900 [Thread-14-TweetCounter-bolt] INFO  backtype.storm.daemon.executor - Prepared bolt TweetCounter-bolt:(6)
18937 [Thread-12-Parse-2-bolt] INFO  backtype.storm.task.ShellBolt - Launched subprocess with pid 13482
18951 [Thread-24-sentence-spout] INFO  backtype.storm.daemon.executor - Opened spout sentence-spout:(10)
18953 [Thread-16-Parse-1-bolt] INFO  backtype.storm.task.ShellBolt - Start checking heartbeat...
18954 [Thread-16-Parse-1-bolt] INFO  backtype.storm.daemon.executor - Prepared bolt Parse-1-bolt:(3)
18987 [Thread-24-sentence-spout] INFO  backtype.storm.daemon.executor - Activating spout sentence-spout:(10)
18990 [Thread-24-sentence-spout] INFO  backtype.storm.spout.ShellSpout - Start checking heartbeat...
19007 [Thread-12-Parse-2-bolt] INFO  backtype.storm.task.ShellBolt - Start checking heartbeat...
19007 [Thread-12-Parse-2-bolt] INFO  backtype.storm.daemon.executor - Prepared bolt Parse-2-bolt:(4)
19144 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 1
19160 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 2
19177 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 1
19178 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 1
19179 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 2
19179 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 1
19198 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 2
19198 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 1
19263 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 1
19314 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 1
19316 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 1
19337 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 1
19350 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 2
19364 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 1
19366 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 1
19368 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 1
19370 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 1
19373 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 1
19389 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 1
19390 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 1
19390 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 1
19395 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 1
19413 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 2
19426 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 1
19427 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 1
19428 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 1
19463 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 1
19445 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 2
19483 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 2
19571 [Thread-26-sentence-spout] INFO  backtype.storm.spout.ShellSpout - Launched subprocess with pid 13484
19571 [Thread-26-sentence-spout] INFO  backtype.storm.daemon.executor - Opened spout sentence-spout:(9)
19572 [Thread-26-sentence-spout] INFO  backtype.storm.daemon.executor - Activating spout sentence-spout:(9)
19572 [Thread-26-sentence-spout] INFO  backtype.storm.spout.ShellSpout - Start checking heartbeat...
19596 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 2
19633 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 3
19634 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 2
19679 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 4
19693 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 2
19703 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 3
19730 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 3
19734 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 2
19804 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 3
19860 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 3
19888 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 4
19924 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 2
19926 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 1
19958 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 4
19975 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 1
19993 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 1
20009 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 3
20014 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 2
20025 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 1
20036 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 1
20073 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 5
20218 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 1
20281 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 4
20285 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 5
20303 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 1
20349 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 1
20350 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 1
20339 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 6
20338 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 6
20318 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 4
20387 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 7
20366 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 5
20353 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 5
20406 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 5
20401 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 1
20435 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 3
20436 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 1
20437 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 1
20438 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 4
20451 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 8
20459 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 1
20460 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 1
20476 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 1
20477 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 3
20487 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 3
20510 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 9
20593 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 3
20615 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 6
20625 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 4
20642 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 2
20661 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 7
20665 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 2
20696 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 6
20815 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 2
20837 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 2
20853 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 8
20868 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 2
20870 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 2
20884 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 7
20924 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 2
20967 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 6
20968 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 5
21032 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 7
21075 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 8
21096 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 10
21100 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 9
21116 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 9
21138 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 10
21142 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 10
21157 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 11
21162 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 11
21198 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 12
21239 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 7
21243 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 8
21261 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 12
21266 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 8
21333 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 13
21336 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 13
21292 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 11
21396 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 2
21447 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 1
21476 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 14
21498 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 12
21501 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 9
21529 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 10
21553 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 15
21555 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 1
21560 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 9
21581 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 1
21586 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 14
21601 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 4
21617 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 10
21639 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 1
21655 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 4
21656 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 1
21716 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 11
21752 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 12
21820 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 13
21833 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 11
21912 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 6
21929 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 15
21952 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 13
21966 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 14
21967 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 16
21981 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 2
21983 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 2
21996 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 2
22005 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 5
22031 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 2
22047 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 5
22047 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 14
22063 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 17
22084 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 16
22100 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 18
22153 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 12
22158 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 19
22190 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 15
22194 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 13
22229 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 16
22233 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 2
22293 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 17
22307 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 7
22312 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 1
22313 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 6
22316 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 2
22327 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 2
22329 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 17
22330 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 2
22359 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 18
22359 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 2
22434 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 5
22435 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 2
22538 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 8
22549 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 18
22550 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 14
22552 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 2
22600 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 2
22617 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 20
22621 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 15
22640 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 15
22687 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 16
22692 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 19
22707 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 17
22782 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 2
22830 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 2
22832 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 7
22852 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 4
22898 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 20
22937 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 19
22949 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 20
23002 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 21
23006 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 18
23021 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 21
23041 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 22
23131 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 16
23171 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 6
23180 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 22
23212 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 23
23234 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 19
23236 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 21
23256 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 6
23298 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 23
23358 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 24
23369 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 20
23410 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 21
23423 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 17
23444 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 24
23513 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 25
23515 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 3
23535 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 22
23576 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 9
23595 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 23
23646 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 3
23673 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 3
23700 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 24
23706 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 26
23716 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 18
23720 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 22
23770 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 23
23771 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 25
23774 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 19
23802 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 26
23826 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 24
23857 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 20
23888 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 21
23912 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 22
23943 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 3
23944 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 3
23962 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 27
23965 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 23
23992 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 3
23993 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 3
23998 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 28
24017 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 29
24024 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 3
24025 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 3
24026 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 24
24040 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 3
24052 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 3
24055 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 7
24076 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 25
24113 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 3
24134 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 25
24137 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 25
24156 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 10
24170 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 3
24170 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 3
24183 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 2
24192 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 2
24224 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 2
24249 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 2
24269 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 2
24281 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 2
24283 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 27
24295 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 5
24303 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 7
24316 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 8
24316 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 2
24323 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 2
24364 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 26
24380 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 30
24419 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 27
24494 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 26
24497 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 27
24547 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 28
24546 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 26
24527 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 28
24507 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 4
24565 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 11
24578 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 4
24582 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 4
24584 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 27
24586 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 29
24647 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 30
24648 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 4
24650 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 28
24698 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 31
24701 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 29
24719 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 31
24751 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 29
24754 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 32
24820 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 33
24849 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 34
24854 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 4
24869 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 28
24882 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 29
24922 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 32
24934 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 35
24955 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 33
24974 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 36
25004 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 37
25008 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 30
25024 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 31
25073 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 30
25154 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 4
25189 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 30
25206 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 32
25210 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 38
25301 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 31
25324 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 32
25345 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 33
25383 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 34
25407 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 35
25408 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 39
25420 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 40
25423 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 4
25488 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 33
25499 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 41
25522 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 31
25533 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 42
25537 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 34
25574 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 35
25588 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 34
25609 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 36
25624 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 35
25677 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 4
25722 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 37
25707 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 43
25693 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 32
25757 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 33
25757 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 36
25793 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 34
25850 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 35
25883 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 36
25930 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 44
25949 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 38
25998 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 37
26004 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 39
26021 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 45
26056 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 46
26091 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 47
26096 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 37
26118 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 48
26256 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 40
26295 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 49
26298 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 41
26311 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 36
26357 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 9
26392 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 42
26470 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 38
26487 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 50
26542 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 51
26573 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 52
26594 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 38
26612 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 43
26627 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 37
26716 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 4
26726 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 39
26766 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 39
26768 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 44
26857 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 40
26886 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 5
26903 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 41
26921 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 42
26966 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 3
26966 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 3
26967 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 3
26968 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 12
26969 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 3
26989 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 38
27023 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 43
27045 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 53
27047 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 39
27073 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 44
27087 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 40
27162 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 45
27171 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 41
27165 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 45
27234 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 40
27254 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 54
27271 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 41
27306 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 42
27343 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 13
27362 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 46
27364 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 46
27369 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 47
27395 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 43
27437 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 44
27487 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 45
27538 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 46
27540 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 48
27586 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 47
27607 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 49
27640 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 50
27680 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 51
27761 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 47
27763 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 5
27914 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 5
27952 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 55
27965 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 48
27981 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 48
27999 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 49
28002 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 52
28015 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 49
28037 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 50
28083 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 53
28103 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 42
28106 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 54
28203 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 50
28238 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 5
28259 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 51
28323 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 56
28324 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 51
28327 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 55
28330 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 43
28372 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 56
28459 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 57
28490 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 58
28506 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 59
28526 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 60
28542 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 52
28556 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 57
28591 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 4
28596 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 58
28612 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 52
28624 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 3
28625 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 5
28646 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 53
28661 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 61
28680 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 62
28699 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 54
28745 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 55
28767 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 56
28904 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 44
28924 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 63
28938 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 57
28964 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 4
28967 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 58
29023 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 4
29028 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 4
29029 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 4
29031 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 4
29040 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 14
29067 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 53
29107 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 54
29123 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 45
29159 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 59
29176 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 55
29179 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 60
29195 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 56
29210 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 4
29241 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 64
29243 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 57
29242 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 4
29261 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 3
29349 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 65
29351 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 59
29376 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 58
29379 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 61
29430 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 3
29431 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 15
29432 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 3
29432 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 3
29433 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 8
29437 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 5
29438 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 66
29440 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 62
29450 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 4
29453 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 59
29469 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 5
29473 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 46
29474 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 5
29476 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 67
29492 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 5
29496 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 5
29498 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 60
29500 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 16
29510 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 4
29511 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 68
29517 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 4
29535 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 60
29536 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 69
29572 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 70
29577 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 61
29594 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 71
29629 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 72
29658 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 61
29698 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 3
29709 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 62
29797 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 8
29804 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 62
29822 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 47
29860 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 3
29876 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 73
29880 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 3
29891 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 48
29896 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 63
29899 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 64
29960 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 49
29964 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 65
29985 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 66
30006 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 67
30028 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 68
30048 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 69
30065 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 63
30062 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 3
30076 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 3
30077 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 3
30077 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 17
30080 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 70
30113 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 3
30114 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 74
30119 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 9
30138 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 3
30139 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 5
30139 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 5
30140 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 5
30140 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 5
30157 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 75
30177 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 3
30177 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 3
30178 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 5
30179 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 4
30212 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 76
30213 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 4
30213 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 4
30214 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 4
30296 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 71
30304 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 64
30321 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 50
30358 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 72
30399 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 51
30412 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 10
30413 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 77
30423 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 4
30424 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 9
30426 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 4
30427 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 18
30438 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 4
30440 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 73
30441 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 5
30443 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 5
30455 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 5
30457 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 5
30459 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 65
30460 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 10
30462 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 74
30471 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 5
30475 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 19
30477 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 4
30479 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 5
30480 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 66
30481 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 5
30493 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 75
30493 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 4
30497 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 4
30510 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 11
30511 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 5
30523 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 10
30524 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 76
30524 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 5
30525 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 20
30527 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 63
30532 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 64
30534 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 5
30549 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 12
30549 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 6
30550 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 11
30551 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 4
30566 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 65
30581 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 66
30652 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 67
30656 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 77
30696 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 78
30709 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 52
30742 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 67
30783 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 53
30812 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 68
30829 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 54
30849 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 69
30863 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 55
30897 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 4
30952 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 79
31039 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 68
31044 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 56
31131 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 80
31178 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 78
31207 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 4
31209 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 81
31248 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 57
31251 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 69
31280 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 70
31281 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 58
31315 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 71
31318 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 59
31419 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 72
31423 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 79
31510 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 82
31525 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 6
31621 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 7
31634 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 80
31637 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 12
31650 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 83
31653 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 11
31654 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 70
31686 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 84
31657 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 6
31655 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 60
31764 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 71
31765 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 61
31785 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 6
31786 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 6
31787 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 21
31788 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 6
31788 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 5
31790 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 6
31804 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 6
31818 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 6
31818 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 6
31819 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 6
31821 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 12
31822 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 6
31832 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 6
31834 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 6
31837 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 6
31850 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 6
31860 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 81
31889 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 73
31915 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 74
31966 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 75
32017 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 62
32031 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 76
32034 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 22
32136 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 72
32139 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 85
32147 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 82
32243 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 63
32275 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 23
32280 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 73
32314 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 74
32318 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 6
32395 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 77
32398 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 75
32435 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 83
32436 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 76
32493 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 77
32499 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 78
32575 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 6
32665 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 5
32683 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 86
32705 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 84
32739 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 87
32740 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 6
32745 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 85
32772 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 64
32812 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 13
32813 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 7
32831 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 24
32841 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 79
32845 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 88
32847 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 65
32848 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 7
32858 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 78
32860 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 5
32861 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 6
32881 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 7
32895 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 7
32897 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 89
32897 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 80
32898 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 79
32899 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 66
32900 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 6
32913 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 6
32917 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 7
32920 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 7
32921 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 81
32921 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 80
32930 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 90
32931 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 7
32932 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 7
32934 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 67
32936 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 5
32947 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 6
32949 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 5
32951 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 6
32962 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 5
32966 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 5
32968 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 6
32984 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 5
33002 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 6
33007 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 82
33007 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 6
33010 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 6
33024 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 91
33033 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 6
33111 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 81
33122 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 68
33157 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 92
33197 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 69
33215 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 82
33230 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 93
33233 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 70
33243 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 6
33243 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 8
33244 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 8
33245 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 8
33245 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 7
33246 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 14
33246 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 7
33247 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 25
33248 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 7
33275 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 7
33283 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 71
33318 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 72
33328 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 83
33331 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 84
33352 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 83
33369 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 84
33415 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 86
33451 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 7
33537 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 13
33555 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 73
33557 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 94
33571 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 85
33592 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 6
33623 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 87
33674 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 13
33657 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 85
33797 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 86
33812 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 86
33819 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 74
33836 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 87
33905 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 75
33934 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 95
33956 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 6
33957 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 76
33958 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 88
33959 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 6
34042 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 14
34055 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 96
34079 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 8
34132 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 87
34132 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 89
34134 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 14
34135 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 88
34140 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 90
34151 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 88
34186 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 89
34188 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 15
34188 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 7
34189 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 15
34190 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 8
34190 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 7
34193 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 16
34215 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 7
34231 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 90
34244 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 8
34246 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 7
34250 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 26
34272 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 89
34275 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 7
34277 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 15
34294 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 8
34305 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 8
34310 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 27
34330 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 90
34334 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 6
34336 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 9
34336 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 9
34349 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 7
34367 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 97
34376 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 91
34451 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 92
34566 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 98
34578 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 7
34608 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 93
34613 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 8
34614 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 28
34616 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 8
34618 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 29
34630 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 7
34645 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 77
34649 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 78
34684 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 7
34687 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 7
34708 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 7
34720 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 79
34752 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 80
34790 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 91
34846 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 7
34847 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 16
34848 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 8
34851 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 99
34883 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 92
34886 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 100
34887 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 16
34888 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 8
34888 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 30
34889 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 8
34924 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 17
34925 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 9
34926 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 9
34961 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 9
34962 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 17
34963 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 9
35031 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 101
34978 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 93
35064 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 94
35072 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 31
35083 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 91
35086 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 9
35098 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 18
35106 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 9
35108 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 95
35119 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 94
35138 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 17
35139 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 81
35176 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 102
35177 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 9
35178 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 32
35179 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 9
35180 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 10
35180 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 10
35182 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 10
35183 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 10
35203 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 103
35212 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 18
35228 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 95
35232 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 96
35268 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 97
35281 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 92
35313 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 10
35319 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 98
35336 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 33
35340 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 10
35349 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 9
35350 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 104
35353 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 105
35354 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 96
35384 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 97
35388 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 99
35405 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 82
35464 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 106
35479 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 9
35498 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 98
35512 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 107
35523 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 99
35538 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 83
35552 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 93
35583 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 94
35600 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 108
35617 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 95
35641 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 109
35654 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 96
35658 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 97
35687 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 84
35726 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 98
35756 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 100
35757 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 99
35781 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 101
35808 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 18
35828 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 102
35831 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 110
35844 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 111
35863 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 103
35893 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 19
35934 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 104
35935 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 100
35973 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 100
36024 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 101
36085 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 102
36086 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 105
36103 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 101
36137 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 103
36161 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 104
36170 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 85
36238 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 112
36250 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 102
36254 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 103
36319 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 105
36335 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 9
36345 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 106
36357 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 113
36361 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 86
36402 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 107
36452 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 108
36455 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 106
36474 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 114
36485 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 107
36502 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 108
36503 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 115
36569 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 116
36584 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 34
36587 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 117
36657 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 8
36689 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 8
36705 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 109
36722 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 104
36735 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 8
36736 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 8
36737 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 8
36741 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 8
36842 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 110
36845 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 87
36864 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 118
36887 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 88
36904 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 119
36991 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 8
37003 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 109
37025 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 105
37090 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 106
37112 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 107
37142 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 8
37141 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 89
37157 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 108
37160 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 90
37260 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 109
37270 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 120
37304 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 91
37333 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 110
37334 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 121
37354 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 8
37370 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 92
37410 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 93
37505 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 7
37591 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 94
37590 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 111
37575 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 122
37565 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 111
37543 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 110
37688 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 112
37689 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 111
37729 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 19
37771 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 112
37772 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 95
37822 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 123
37828 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 35
37859 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 10
37859 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 96
37895 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 97
37897 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 7
37898 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 8
37899 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 19
37931 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 7
37952 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 112
37975 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 113
37988 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 113
37995 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 124
38053 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 8
38054 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 20
38054 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 7
38055 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 10
38056 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 10
38059 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 36
38060 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 9
38060 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 10
38062 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 9
38080 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 8
38144 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 113
38194 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 114
38211 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 114
38268 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 7
38275 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 98
38293 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 114
38294 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 125
38304 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 115
38306 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 37
38310 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 8
38330 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 10
38336 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 11
38350 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 7
38352 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 126
38354 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 20
38356 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 115
38365 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 116
38369 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 10
38382 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 9
38389 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 20
38389 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 99
38402 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 9
38409 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 117
38464 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 116
38434 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 127
38420 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 100
38417 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 10
38515 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 38
38516 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 9
38518 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 10
38519 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 9
38531 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 101
38531 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 9
38533 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 9
38535 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 9
38535 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 117
38536 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 10
38552 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 7
38572 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 115
38584 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 10
38585 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 7
38586 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 11
38602 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 128
38607 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 21
38620 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 11
38631 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 11
38633 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 11
38651 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 21
38755 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 11
38772 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 118
38782 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 116
38783 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 21
38787 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 22
38801 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 11
38805 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 39
38815 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 117
38819 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 119
38820 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 40
38873 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 11
38875 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 129
38890 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 120
38893 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 10
38904 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 10
38905 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 11
38905 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 41
38910 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 9
38926 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 9
38927 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 9
38957 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 9
38929 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 130
38960 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 11
38961 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 11
38978 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 11
38980 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 8
38989 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 121
39020 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 131
39054 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 132
39076 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 118
39097 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 133
39184 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 119
39186 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 122
39202 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 8
39216 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 134
39223 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 8
39235 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 102
39236 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 8
39237 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 120
39248 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 8
39249 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 123
39250 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 8
39303 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 8
39307 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 8
39308 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 121
39320 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 9
39321 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 124
39321 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 103
39322 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 12
39334 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 12
39335 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 12
39339 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 135
39341 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 12
39342 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 104
39344 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 23
39360 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 136
39380 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 105
39394 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 106
39422 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 107
39397 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 137
39428 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 118
39445 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 138
39534 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 122
39540 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 108
39553 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 125
39612 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 12
39647 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 42
39655 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 12
39713 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 126
39730 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 119
39796 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 120
39867 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 127
39872 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 109
39900 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 12
39901 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 12
39902 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 22
39903 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 11
39922 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 22
39923 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 11
39924 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 43
39934 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 110
39957 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 111
39970 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 123
40006 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 112
40008 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 121
40012 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 122
39977 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 139
40077 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 11
40097 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 13
40144 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 123
40145 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 124
40150 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 140
40165 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 113
40186 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 125
40201 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 114
40213 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 141
40238 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 142
40255 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 126
40267 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 143
40270 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 115
40325 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 144
40366 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 128
40370 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 116
40391 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 129
40387 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 13
40393 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 13
40405 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 117
40427 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 118
40458 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 119
40378 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 145
40531 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 13
40446 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 130
40556 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 24
40558 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 127
40570 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 13
40575 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 120
40588 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 44
40602 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 13
40608 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 13
40613 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 13
40624 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 128
40625 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 23
40641 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 121
40643 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 12
40678 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 146
40711 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 122
40727 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 123
40745 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 131
40811 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 132
40819 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 124
40865 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 125
40881 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 129
40885 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 126
40904 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 127
40957 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 147
40960 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 148
40963 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 23
40976 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 124
40995 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 125
41029 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 25
41060 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 12
41061 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 45
41061 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 12
41063 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 133
41068 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 149
41082 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 130
41103 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 134
41173 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 150
41176 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 135
41211 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 128
41236 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 131
41256 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 10
41259 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 132
41304 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 129
41469 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 10
41470 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 130
41489 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 10
41502 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 10
41505 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 136
41507 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 46
41523 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 133
41524 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 10
41546 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 10
41567 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 10
41580 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 151
41595 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 152
41596 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 10
41600 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 131
41631 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 153
41604 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 10
41637 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 12
41637 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 11
41638 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 11
41648 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 11
41669 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 154
41704 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 126
41736 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 155
41755 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 11
41770 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 127
41775 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 11
41788 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 156
41791 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 137
41805 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 134
41808 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 128
41817 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 12
41819 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 12
41822 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 135
41921 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 12
41939 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 138
41953 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 132
41955 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 157
41968 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 129
41970 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 12
41973 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 12
41985 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 11
41990 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 12
42000 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 9
42006 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 9
42008 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 9
42024 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 9
42050 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 9
42067 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 130
42068 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 9
42082 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 11
42083 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 47
42084 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 11
42087 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 158
42116 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 11
42116 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 12
42134 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 159
42148 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 48
42148 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 12
42149 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 24
42170 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 13
42170 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 24
42173 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 160
42189 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 136
42171 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 26
42204 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 11
42204 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 11
42205 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 14
42235 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 133
42240 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 137
42255 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 14
42372 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 14
42397 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 138
42400 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 134
42413 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 131
42453 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 139
42465 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 139
42531 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 140
42589 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 141
42629 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 140
42726 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 9
42728 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 142
42801 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 132
42955 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 11
42977 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 14
42988 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 143
42990 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 161
42993 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 13
43013 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 12
43034 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 27
43039 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 144
43051 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 14
43054 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 49
43075 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 14
43102 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 14
43106 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 14
43118 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 25
43125 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 162
43126 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 12
43130 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 25
43163 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 163
43189 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 164
43213 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 141
43240 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 165
43283 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 166
43297 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 145
43300 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 135
43321 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 146
43419 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 133
43421 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 12
43437 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 50
43441 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 12
43460 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 142
43463 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 26
43465 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 134
43483 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 14
43504 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 26
43537 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 28
43539 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 143
43541 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 135
43543 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 14
43561 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 51
43562 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 147
43575 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 13
43590 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 13
43595 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 13
43598 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 144
43600 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 13
43617 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 148
43654 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 145
43701 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 146
43713 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 136
43716 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 137
43733 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 136
43748 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 147
43782 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 167
43789 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 148
43919 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 149
43921 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 137
43926 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 149
43927 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 13
43943 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 138
43962 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 13
43963 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 168
43978 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 13
43983 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 13
43986 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 13
44002 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 52
44014 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 150
44020 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 13
44021 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 169
44035 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 13
44054 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 12
44062 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 12
44063 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 151
44080 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 150
44081 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 170
44091 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 15
44097 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 138
44110 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 139
44135 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 151
44127 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 152
44174 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 152
44209 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 15
44210 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 15
44211 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 15
44213 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 153
44212 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 153
44282 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 29
44357 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 15
44392 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 53
44405 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 15
44409 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 140
44410 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 15
44420 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 54
44439 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 14
44443 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 171
44459 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 141
44462 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 14
44473 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 14
44475 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 14
44479 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 14
44493 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 142
44495 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 14
44512 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 14
44519 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 172
44521 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 143
44549 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 144
44552 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 173
44555 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 154
44589 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 155
44610 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 154
44655 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 155
44657 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 145
44696 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 14
44734 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 156
44747 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 156
44769 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 174
44772 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 14
44794 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 55
44815 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 175
44832 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 14
44845 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 157
44856 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 157
44866 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 14
44867 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 13
44885 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 13
44900 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 176
44901 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 10
44917 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 177
44939 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 146
44943 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 178
44944 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 139
44979 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 179
45019 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 158
45025 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 180
45105 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 10
45110 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 10
45121 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 181
45138 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 10
45138 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 10
45139 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 10
44981 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 140
45264 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 147
45313 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 158
45334 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 10
45356 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 27
45376 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 15
45388 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 159
45393 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 27
45395 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 30
45411 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 160
45415 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 15
45495 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 141
45478 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 159
45582 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 142
45586 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 160
45599 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 148
45624 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 143
45653 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 149
45667 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 182
45673 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 150
45686 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 161
45763 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 56
45797 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 161
45808 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 162
45820 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 144
45867 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 145
45870 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 183
45906 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 184
45907 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 146
45966 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 147
45987 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 148
46042 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 151
46058 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 162
46061 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 163
46113 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 149
46143 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 152
46318 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 164
46333 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 163
46334 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 153
46373 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 154
46391 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 165
46402 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 164
46416 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 150
46471 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 166
46510 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 167
46522 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 165
46556 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 166
46595 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 185
46651 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 186
46693 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 15
46700 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 155
46713 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 187
46754 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 156
46756 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 168
46820 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 151
46915 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 167
46959 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 152
46964 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 168
47013 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 15
47034 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 153
47054 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 169
47056 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 157
47103 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 170
47108 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 154
47161 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 158
47240 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 169
47301 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 188
47379 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 189
47383 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 15
47396 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 171
47399 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 159
47425 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 155
47471 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 156
47476 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 170
47508 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 190
47540 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 171
47543 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 157
47557 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 191
47592 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 158
47635 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 159
47651 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 192
47680 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 160
47737 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 172
47878 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 161
47887 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 15
47912 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 15
47927 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 15
47930 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 193
47940 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 15
47944 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 15
47950 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 15
47977 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 57
48007 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 15
48016 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 15
48122 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 172
48137 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 162
48157 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 163
48176 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 194
48073 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 14
48187 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 14
48188 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 28
48194 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 195
48204 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 13
48204 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 11
48205 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 28
48227 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 15
48230 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 160
48275 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 173
48297 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 173
48369 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 196
48376 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 15
48390 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 161
48453 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 164
48467 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 165
48489 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 162
48606 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 174
48631 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 175
48662 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 12
48704 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 197
48725 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 166
48743 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 163
48774 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 174
48813 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 167
48823 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 175
48861 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 12
48892 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 164
48894 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 198
48896 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 176
48961 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 165
48966 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 11
48977 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 199
49005 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 176
49022 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 168
49026 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 166
49055 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 169
49074 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 167
49080 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 170
49091 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 177
49110 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 171
49114 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 178
49202 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 168
49198 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 200
49193 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 177
49158 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 11
49145 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 172
49301 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 201
49303 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 179
49313 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 178
49331 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 202
49337 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 180
49356 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 179
49389 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 180
49399 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 181
49405 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 181
49403 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 203
49420 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 204
49438 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 182
49485 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 173
49489 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 174
49505 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 183
49523 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 175
49546 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 176
49559 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 177
49575 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 184
49605 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 11
49608 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 205
49615 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 206
49627 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 182
49631 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 178
49684 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 11
49697 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 169
49701 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 179
49713 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 185
49768 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 186
49810 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 183
49826 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 170
49865 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 184
49869 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 171
49907 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 185
49926 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 172
49932 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 186
49967 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 11
49968 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 11
49968 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 29
49991 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 207
49994 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 16
49995 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 29
49996 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 31
50025 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 15
50026 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 13
50027 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 16
50027 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 30
50062 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 187
50099 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 17
50143 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 30
50187 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 180
50184 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 173
50173 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 208
50171 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 187
50195 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 32
50208 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 17
50225 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 58
50261 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 16
50294 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 209
50306 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 188
50334 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 210
50366 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 211
50390 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 212
50406 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 181
50425 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 182
50439 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 188
50442 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 183
50460 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 16
50466 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 184
50482 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 185
50513 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 16
50514 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 16
50515 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 16
50594 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 174
50596 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 13
50597 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 213
50602 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 59
50616 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 13
50630 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 16
50632 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 189
50634 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 16
50645 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 214
50647 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 16
50649 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 190
50664 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 186
50670 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 16
50683 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 33
50686 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 215
50687 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 16
50699 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 60
50701 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 16
50705 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 16
50715 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 16
50718 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 13
50720 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 216
50731 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 61
50732 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 191
50732 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 17
50735 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 192
50735 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 12
50747 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 217
50747 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 17
50748 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 12
50749 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 17
50749 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 12
50756 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 12
50756 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 17
50758 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 12
50758 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 17
50768 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 12
50806 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 16
50786 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 193
50786 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 189
50819 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 194
50839 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 175
50843 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 31
50884 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 176
50876 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 190
50887 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 14
50888 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 16
50889 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 16
50875 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 187
50976 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 191
50980 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 177
50964 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 195
51026 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 188
51031 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 192
51031 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 196
51097 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 193
51111 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 178
51134 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 179
51199 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 16
51216 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 180
51235 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 62
51237 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 181
51254 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 16
51256 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 16
51256 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 16
51265 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 16
51294 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 189
51299 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 182
51311 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 194
51315 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 197
51332 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 190
51447 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 15
51448 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 195
51449 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 14
51452 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 13
51452 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 198
51454 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 13
51455 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 183
51465 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 218
51478 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 13
51488 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 196
51491 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 13
51499 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 13
51530 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 197
51562 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 198
51564 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 219
51584 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 199
51589 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 220
51606 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 221
51634 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 191
51639 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 199
51654 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 200
51672 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 192
51676 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 201
51687 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 13
51688 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 32
51689 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 18
51689 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 31
51721 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 184
51723 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 34
51696 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 193
51718 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 202
51754 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 194
51777 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 185
51783 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 195
51793 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 18
51886 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 200
51935 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 186
51939 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 196
51969 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 203
52010 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 197
52028 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 204
52048 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 205
52067 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 63
52068 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 18
52071 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 222
52082 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 18
52083 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 18
52107 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 18
52143 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 187
52145 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 223
52147 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 198
52178 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 18
52198 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 224
52216 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 201
52200 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 188
52279 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 17
52339 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 199
52351 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 17
52365 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 17
52378 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 17
52392 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 225
52397 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 64
52397 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 17
52398 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 226
52401 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 206
52419 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 189
52423 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 17
52437 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 17
52443 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 17
52455 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 14
52458 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 14
52458 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 207
52462 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 14
52496 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 208
52609 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 190
52638 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 227
52642 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 14
52643 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 14
52644 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 14
52663 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 33
52723 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 191
52727 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 202
52748 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 14
52775 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 203
52815 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 228
52865 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 192
52883 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 229
52887 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 193
52915 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 230
52942 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 32
52988 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 231
53005 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 209
53041 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 200
53042 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 232
53046 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 210
53059 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 194
53114 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 211
53115 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 201
53200 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 14
53217 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 195
53220 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 65
53236 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 14
53252 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 16
53254 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 233
53268 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 15
53281 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 204
53286 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 205
53300 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 15
53305 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 15
53317 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 206
53323 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 15
53335 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 196
53337 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 15
53338 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 15
53351 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 15
53355 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 17
53368 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 16
53371 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 16
53374 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 16
53392 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 16
53403 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 15
53419 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 33
53429 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 18
53456 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 18
53457 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 202
53476 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 18
53493 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 18
53511 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 66
53513 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 203
53525 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 18
53530 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 204
53540 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 18
53544 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 18
53558 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 18
53566 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 17
53576 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 205
53598 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 212
53613 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 197
53649 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 17
53668 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 198
53678 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 207
53685 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 17
53698 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 17
53703 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 35
53716 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 234
53720 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 34
53730 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 199
53741 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 208
53758 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 206
53826 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 207
53847 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 208
53848 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 200
53879 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 201
53882 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 202
53902 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 16
53916 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 235
53943 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 203
53969 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 204
54038 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 209
54070 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 209
54014 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 205
54139 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 236
54178 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 213
54208 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 237
54252 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 214
54267 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 206
54269 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 210
54305 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 34
54334 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 238
54343 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 239
54374 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 240
54389 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 15
54391 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 67
54394 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 241
54408 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 210
54424 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 207
54427 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 15
54456 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 17
54457 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 18
54458 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 18
54464 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 215
54476 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 18
54480 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 18
54481 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 242
54482 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 36
54495 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 216
54532 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 17
54562 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 211
54568 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 208
54572 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 68
54615 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 212
54656 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 213
54687 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 209
54727 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 210
54746 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 243
54780 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 211
54783 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 17
54799 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 16
54800 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 16
54801 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 16
54801 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 69
54802 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 16
54819 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 212
54839 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 19
54859 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 214
54874 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 19
54910 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 215
54915 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 211
54928 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 19
54929 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 19
54930 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 17
54931 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 17
54931 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 18
54932 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 70
54933 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 18
54934 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 18
55002 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 18
55010 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 213
55030 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 216
55059 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 212
55080 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 214
55100 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 18
55101 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 217
55112 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 18
55115 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 17
55132 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 217
55147 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 213
55149 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 18
55166 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 17
55183 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 215
55308 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 218
55390 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 17
55394 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 219
55413 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 218
55422 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 214
55450 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 219
55453 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 220
55455 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 17
55535 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 244
55556 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 221
55575 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 216
55616 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 217
55631 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 220
55633 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 222
55656 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 221
55665 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 223
55702 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 215
55718 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 216
55719 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 224
55723 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 245
55739 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 217
55742 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 225
55789 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 218
55809 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 226
55810 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 219
55825 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 222
55829 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 227
55831 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 220
55845 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 223
55878 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 218
55905 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 18
55937 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 224
56020 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 228
56023 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 246
56046 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 247
56058 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 229
56089 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 230
56105 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 35
56129 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 231
56143 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 232
56145 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 221
56162 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 225
56166 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 226
56200 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 222
56202 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 227
56218 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 219
56257 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 220
56263 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 223
56280 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 224
56276 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 221
56266 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 228
56291 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 248
56312 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 229
56360 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 37
56380 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 233
56385 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 249
56398 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 19
56414 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 71
56438 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 230
56448 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 19
56459 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 234
56464 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 222
56477 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 223
56495 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 19
56512 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 19
56528 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 18
56544 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 17
56546 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 224
56548 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 16
56552 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 18
56566 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 235
56571 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 19
56572 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 250
56575 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 18
56588 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 17
56593 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 231
56603 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 20
56607 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 225
56622 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 251
56627 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 19
56640 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 19
56645 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 19
56661 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 19
56692 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 19
56693 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 19
56694 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 18
56760 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 36
56761 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 232
56799 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 252
56814 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 226
56815 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 236
56828 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 233
56851 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 253
56885 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 234
56900 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 254
56926 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 235
56941 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 227
56945 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 255
56969 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 236
56971 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 256
57004 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 237
57023 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 228
57045 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 238
57074 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 237
57096 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 238
57126 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 239
57132 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 239
57198 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 19
57214 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 240
57217 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 229
57230 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 225
57263 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 230
57264 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 226
57296 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 227
57297 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 231
57322 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 228
57354 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 229
57371 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 230
57437 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 240
57454 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 257
57472 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 241
57476 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 258
57489 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 232
57508 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 242
57527 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 259
57558 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 233
57562 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 260
57564 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 231
57584 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 243
57588 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 234
57607 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 244
57671 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 261
57686 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 232
57709 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 241
57730 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 245
57749 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 262
57756 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 235
57793 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 263
57796 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 246
57838 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 247
57877 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 248
57892 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 249
57910 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 233
57937 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 250
57973 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 234
57961 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 35
57947 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 242
58057 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 38
58094 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 251
58096 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 235
58098 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 19
58117 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 72
58127 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 264
58167 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 243
58170 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 244
58179 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 236
58184 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 252
58197 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 265
58235 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 237
58257 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 236
58280 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 238
58308 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 237
58321 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 239
58379 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 238
58389 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 240
58405 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 239
58482 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 19
58520 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 253
58570 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 266
58585 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 240
58628 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 241
58639 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 241
58643 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 267
58674 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 242
58707 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 268
58714 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 254
58716 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 243
58759 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 269
58760 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 255
58781 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 256
58853 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 242
58859 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 19
58877 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 257
58878 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 19
58892 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 19
58894 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 245
58920 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 19
58951 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 19
58975 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 19
58987 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 19
58991 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 19
59004 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 19
59012 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 21
59028 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 20
59030 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 20
59031 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 73
59035 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 19
59049 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 19
59051 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 19
59064 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 19
59068 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 20
59078 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 20
59080 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 20
59095 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 20
59095 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 20
59096 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 22
59097 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 20
59097 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 20
59118 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 20
59118 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 36
59119 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 37
59150 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 21
59151 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 39
59155 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 243
59171 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 258
59169 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 21
59358 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 244
59363 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 270
59379 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 20
59379 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 259
59379 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 246
59383 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 21
59388 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 74
59399 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 271
59440 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 245
59444 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 272
59462 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 247
59466 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 273
59484 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 248
59486 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 246
59516 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 274
59517 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 247
59533 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 249
59560 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 248
59597 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 260
59599 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 244
59605 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 21
59605 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 20
59606 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 37
59682 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 20
59686 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 250
59725 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 251
59738 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 245
59810 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 252
59825 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 275
59827 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 246
59850 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 253
59944 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 276
59978 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 247
59996 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 277
59998 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 249
60001 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 40
60015 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 254
60043 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 248
60168 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 21
60205 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 21
60206 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 21
60220 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 278
60223 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 279
60247 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 250
60357 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 255
60374 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 249
60394 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 75
60398 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 250
60409 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 261
60427 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 251
60442 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 256
60461 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 252
60464 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 257
60483 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 262
60495 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 258
60586 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 253
60598 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 259
60616 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 263
60618 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 280
60638 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 251
60654 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 260
60705 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 281
60724 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 261
60726 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 252
60765 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 282
60771 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 264
60782 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 262
60787 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 283
60817 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 284
60850 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 285
60912 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 286
60974 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 21
61008 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 254
61023 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 253
61030 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 287
61065 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 254
61085 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 265
61110 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 266
61132 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 255
61133 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 255
61148 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 267
61170 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 256
61210 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 257
61221 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 268
61233 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 258
61255 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 269
61261 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 263
61265 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 259
61297 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 264
61366 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 21
61396 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 256
61401 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 270
61452 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 288
61467 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 271
61504 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 265
61522 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 289
61539 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 266
61554 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 290
61577 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 272
61595 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 291
61598 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 273
61616 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 292
61618 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 274
61698 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 38
61730 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 275
61742 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 257
61750 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 267
61767 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 260
61840 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 261
61873 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 258
61956 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 22
61958 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 38
61978 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 293
61992 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 294
62012 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 41
62013 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 22
62024 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 276
62024 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 76
62025 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 21
62029 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 20
62032 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 20
62050 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 42
62061 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 20
62078 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 277
62099 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 268
62114 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 77
62125 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 262
62147 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 259
62152 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 278
62168 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 260
62188 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 269
62204 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 20
62205 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 20
62206 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 22
62218 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 263
62219 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 261
62220 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 21
62221 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 20
62222 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 270
62254 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 262
62271 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 295
62285 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 20
62289 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 296
62303 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 20
62304 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 21
62305 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 21
62305 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 21
62308 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 263
62320 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 20
62322 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 271
62322 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 297
62326 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 20
62337 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 20
62339 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 20
62342 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 78
62342 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 264
62343 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 298
62345 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 20
62360 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 20
62362 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 20
62365 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 20
62368 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 21
62370 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 21
62380 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 272
62381 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 21
62383 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 21
62384 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 43
62396 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 21
62400 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 79
62401 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 299
62505 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 279
62508 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 300
62537 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 265
62571 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 21
62571 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 22
62572 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 22
62573 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 22
62574 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 22
62575 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 266
62577 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 273
62587 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 22
62608 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 274
62693 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 301
62695 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 264
62728 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 267
62741 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 265
62767 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 275
62778 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 268
62780 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 269
62800 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 22
62812 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 270
62813 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 280
62830 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 22
62831 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 20
62832 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 39
62832 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 17
62863 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 39
62864 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 22
62870 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 17
62871 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 22
62918 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 40
62923 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 302
62935 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 276
62937 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 271
62940 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 80
62954 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 17
62972 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 22
62988 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 272
63010 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 281
63021 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 266
63025 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 267
63063 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 268
63073 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 277
63092 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 269
63114 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 270
63145 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 271
63220 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 282
63236 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 303
63328 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 23
63342 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 272
63345 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 304
63385 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 273
63394 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 40
63395 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 278
63424 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 274
63453 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 44
63464 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 275
63485 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 276
63500 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 279
63504 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 277
63516 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 278
63517 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 280
63540 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 305
63541 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 281
63556 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 283
63557 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 279
63604 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 306
63608 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 284
63637 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 285
63640 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 23
63642 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 273
63696 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 21
63717 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 286
63726 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 307
63731 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 282
63745 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 274
63760 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 21
63761 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 81
63782 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 23
63799 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 280
63818 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 23
63834 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 281
63885 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 282
64104 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 275
64122 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 23
64138 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 287
64139 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 283
64142 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 308
64159 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 276
64165 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 283
64179 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 284
64191 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 309
64236 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 277
64253 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 284
64297 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 285
64304 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 286
64317 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 287
64339 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 288
64374 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 289
64383 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 288
64471 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 289
64472 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 285
64477 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 290
64510 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 278
64514 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 286
64524 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 310
64545 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 287
64582 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 291
64598 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 279
64610 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 292
64611 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 22
64626 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 293
64635 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 294
64653 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 295
64669 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 311
64706 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 296
64706 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 290
64711 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 312
64745 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 313
64804 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 22
64818 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 297
64846 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 298
64861 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 288
64866 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 299
64927 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 300
64985 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 301
64987 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 21
65017 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 302
65032 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 303
65047 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 280
65064 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 304
65066 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 21
65084 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 305
65123 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 306
65128 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 281
65141 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 289
65145 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 23
65162 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 307
65253 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 282
65182 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 23
65182 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 290
65258 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 291
65274 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 314
65286 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 23
65289 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 291
65305 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 23
65307 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 23
65310 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 292
65329 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 315
65363 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 293
65363 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 283
65376 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 23
65377 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 22
65377 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 23
65393 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 316
65395 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 284
65397 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 294
65411 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 21
65414 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 317
65418 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 23
65433 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 295
65440 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 296
65457 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 318
65489 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 319
65493 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 297
65512 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 320
65524 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 308
65539 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 298
65542 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 292
65592 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 23
65613 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 309
65628 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 23
65639 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 321
65640 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 293
65642 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 285
65663 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 22
65675 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 23
65677 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 23
65680 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 22
65691 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 21
65691 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 322
65692 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 286
65710 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 299
65729 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 300
65730 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 323
65749 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 324
65750 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 301
65765 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 302
65781 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 325
65782 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 303
65796 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 326
65800 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 310
65816 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 287
65814 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 304
65834 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 288
65840 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 289
65855 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 294
65876 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 305
65940 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 82
65990 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 21
65991 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 290
66030 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 21
66032 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 306
66034 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 291
66035 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 311
66065 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 21
66087 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 292
66117 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 312
66122 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 313
66138 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 314
66143 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 327
66173 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 21
66188 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 315
66193 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 307
66206 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 316
66226 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 308
66243 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 293
66271 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 294
66273 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 328
66323 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 295
66335 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 41
66353 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 309
66359 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 18
66376 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 295
66379 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 317
66393 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 41
66412 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 329
66430 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 296
66431 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 18
66447 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 83
66459 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 330
66459 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 297
66478 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 331
66497 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 298
66528 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 299
66567 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 310
66620 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 296
66621 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 18
66689 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 22
66702 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 300
66721 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 311
66743 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 301
66753 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 318
66754 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 297
66775 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 312
66778 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 298
66780 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 302
66865 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 319
66841 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 313
66824 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 22
66824 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 299
66896 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 314
66901 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 315
66911 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 22
66912 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 45
66912 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt I: 23
66913 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt was: 23
66913 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt very: 23
66914 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 22
66915 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt glad: 23
66915 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 46
66916 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt get: 23
66928 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 84
66949 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 320
66963 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 316
66980 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 317
67003 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 332
67117 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 22
67122 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 300
67124 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 22
67187 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 318
67192 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 319
67192 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 321
67193 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 303
67193 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 22
67194 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 333
67212 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 322
67242 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 24
67243 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 24
67243 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 24
67244 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 24
67245 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 24
67264 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 323
67286 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 320
67300 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 304
67302 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 324
67306 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 321
67321 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 305
67322 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 325
67385 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 322
67406 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 306
67473 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 24
67557 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 307
67552 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 326
67501 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 301
67488 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 323
67640 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 327
67641 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 308
67645 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 309
67659 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 24
67659 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 24
67660 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 42
67660 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 24
67663 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 328
67663 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 334
67679 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 42
67680 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 47
67691 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 329
67693 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 335
67693 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 310
67764 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 330
67777 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 324
67815 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 24
67837 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 311
67882 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 85
67884 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 312
67885 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt present: 23
67888 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt from: 23
67890 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 336
67904 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 325
67917 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 326
67929 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt her: 23
67941 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 23
67943 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 22
67944 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 337
67946 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 86
67948 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 87
67949 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 24
67961 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 22
67962 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 24
67965 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 22
67978 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 22
67979 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 327
67995 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 331
68019 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 302
68046 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 328
68050 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 329
68052 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 313
68086 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 330
68101 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 332
68105 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 24
68121 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 338
68204 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 314
68207 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 339
68207 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 333
68230 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 315
68246 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 303
68249 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 334
68281 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 335
68282 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 316
68286 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 304
68340 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 331
68414 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 332
68416 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 333
68519 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 22
68527 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 305
68542 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 334
68554 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 336
68555 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 24
68560 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 317
68578 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 43
68579 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 306
68589 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 335
68605 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 318
68617 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 340
68621 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt immediately: 24
68656 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt quit: 24
68659 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 341
68673 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt work: 24
68679 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 342
68708 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 343
68725 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 344
68742 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 345
68761 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 319
68765 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 337
68784 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 346
68800 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 307
68805 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 19
68805 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 347
68876 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 308
68883 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 320
68916 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 338
68917 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 321
68935 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 309
68953 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 339
68970 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 322
69043 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 43
69130 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 340
69133 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 341
69150 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt and: 24
69151 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 342
69171 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 343
69185 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 348
69198 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 344
69197 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 323
69265 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 19
69270 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 336
69293 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 345
69302 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 349
69305 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 337
69306 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 23
69320 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 88
69334 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 89
69335 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 310
69372 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 311
69392 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 350
69393 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 338
69398 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 312
69417 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 339
69435 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 340
69574 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 23
69577 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 346
69578 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 351
69579 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 324
69594 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 313
69597 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 341
69617 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 314
69646 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 325
69655 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 347
69670 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 315
69702 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 348
69721 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 316
69738 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 349
69846 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 317
69901 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 326
69963 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 350
69965 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 318
69966 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 352
69981 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 319
69984 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 351
69995 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 353
70022 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 352
70023 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 320
70040 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 353
70041 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 354
70049 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 355
70050 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 354
70066 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 355
70079 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 356
70092 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 357
70095 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 358
70108 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 359
70119 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 321
70129 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 360
70144 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 19
70196 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 342
70205 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 327
70214 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 361
70230 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 328
70300 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt around: 23
70300 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 343
70333 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 356
70369 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 357
70383 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 329
70386 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 330
70401 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 344
70416 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 44
70433 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 345
70435 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt the: 23
70436 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt world: 23
70453 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt He: 25
70453 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt will: 25
70454 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt saw: 20
70464 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 346
70465 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 44
70465 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt eating: 20
70466 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 90
70467 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt sandwich: 20
70475 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt She: 45
70475 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt be: 25
70485 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 347
70505 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 331
70541 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 322
70575 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 323
70618 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 324
70631 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 325
70694 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 362
70717 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 348
70725 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 332
70738 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 326
70753 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 349
70757 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 358
70802 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 359
70838 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 333
70884 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 350
70907 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 360
70923 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 351
70938 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 361
70973 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 362
71038 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt here: 25
71038 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 334
71073 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 363
71085 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt in: 25
71090 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 363
71103 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt took: 24
71119 [Thread-39] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13480, name:Parse-1-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 364
71123 [Thread-45] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13482, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 364
71124 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 91
71134 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt trip: 24
71139 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 352
71144 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt half: 25
71155 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt advised: 25
71159 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt him: 45
71171 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt to: 48
71172 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'saw'], [u'him'], [u'eating'], [u'a'], [u'sandwich']]: 353
71174 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt take: 25
71186 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt a: 92
71190 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt an: 25
71192 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt hour: 25
71202 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt long: 25
71204 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt holiday: 25
71205 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt so: 25
71209 [Thread-41] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13483, name:TweetCounter-bolt he: 25
71228 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'She'], [u'advised'], [u'him'], [u'to'], [u'take'], [u'a'], [u'long'], [u'holiday'], [u'so'], [u'he'], [u'immediately'], [u'quit'], [u'work'], [u'and'], [u'took'], [u'a'], [u'trip'], [u'around'], [u'the'], [u'world']]: 354
71256 [Thread-35] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13481, name:Parse-2-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 355
71292 [Thread-36] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13486, name:Parse-1-bolt [[u'I'], [u'was'], [u'very'], [u'glad'], [u'to'], [u'get'], [u'a'], [u'present'], [u'from'], [u'her']]: 327
71296 [Thread-43] INFO  backtype.storm.task.ShellBolt - ShellLog pid:13485, name:Parse-1-bolt [[u'He'], [u'will'], [u'be'], [u'here'], [u'in'], [u'half'], [u'an'], [u'hour']]: 335
Traceback (most recent call last):
  File "/usr/bin/sparse", line 9, in <module>
    load_entry_point('streamparse==2.1.4', 'console_scripts', 'sparse')()
  File "/usr/lib/python2.7/site-packages/streamparse/cli/sparse.py", line 57, in main
    args.func(args)
  File "/usr/lib/python2.7/site-packages/streamparse/cli/run.py", line 81, in main
    debug=args.debug)
  File "/usr/lib/python2.7/site-packages/streamparse/cli/run.py", line 52, in run_local_topology
    run(full_cmd)
  File "/usr/lib/python2.7/site-packages/invoke/__init__.py", line 32, in run
    return Context().run(command, **kwargs)
  File "/usr/lib/python2.7/site-packages/invoke/context.py", line 53, in run
    return runner_class(context=self).run(command, **kwargs)
  File "/usr/lib/python2.7/site-packages/invoke/runners.py", line 335, in run
    raise exception
KeyboardInterrupt
[root@ip-172-31-9-113 tweetcount]# 
```