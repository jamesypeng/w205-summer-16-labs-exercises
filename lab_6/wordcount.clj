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
                :p 1
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
                :p 1
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