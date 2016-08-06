from pyspark import SparkContext
from pyspark.streaming import StreamingContext
import json

ssc = StreamingContext(sc, 10)
lines = ssc.textFileStream("file:////root/lab_10/datastream")
slines = lines.flatMap(lambda x: [ j['venue'] for j in json.loads('['+x+']') if 'venue' in j] )
cnt=slines.count()
cnt.pprint()
slines.pprint()

slines.saveAsTextFiles("file:////root/lab_10/venue_log")

ssc.start()