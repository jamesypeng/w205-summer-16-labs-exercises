(ns wordcount
  (:use     [streamparse.specs])
  (:gen-class))

(defn wordcount [options]
   [
    ;; spout configuration
    {"X-spout" (python-spout-spec
                ;; topology options passed in
                options
                ;; name of the python class to "run"
                "spouts.sentences.Sentences"
                ;; output specification, what named fields will this spout emit
                ["sentence"]
                ;; configuration paramters, can specify multiple
                :p 1)
    }
    
    ;; bolt configuration
    {"Y-bolt"   (python-bolt-spec
                ;; topology options passed in
                options
                ;; inputs, where does this bolt receives its tuples from ?
                {"X-spout" :shuffle}
                ;; class to run 
                "bolts.parse.ParseTweet"
                ;; output spec, what tuples does this bolt emit
                ["word"]
                ;; configuration paramters
                ;; ":p" - the parallelsim thread  
                :p 1)
    }
    
    ;; bolt configuration
    {"Z-bolt"   (python-bolt-spec
                options
                {"Y-spout" :shuffle}
                ;; class to run 
                "bolts.tweetcounter.TweetCount"
                ;; output spec, what tuples does this bolt emit
                ["word" "count"]
                :p 1)
    }
    ]
)