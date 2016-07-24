from __future__ import absolute_import, print_function, unicode_literals

from collections import Counter
from streamparse.bolt import Bolt
import psycopg2

# psql --host=localhost --username=w205 --password --dbname=tcount 
class WordCounter(Bolt):

    def initialize(self, conf, ctx):
        self.counts = Counter()
		self.conn = psycopg2.connect(database="tcount", user="w205", password="postgres", host="localhost", port="5432")
#        self.redis = StrictRedis()

    def process(self, tup):
        word = tup.values[0]

        # Write codes to increment the word count in Postgres
        # Use psycopg to interact with Postgres
        # Database name: Tcount 
        # Table name: Tweetwordcount 
        # you need to create both the database and the table in advance.

		cur = conn.cursor()
		#cur.execute("SELECT upsert('k', 3 );)");
		cur.execute("SELECT upsert(%s,%d)", (uWord, 1))
        conn.commit()


        # Increment the local count
        self.counts[word] += 1
        self.emit([word, self.counts[word]])

        # Log the count - just to see the topology running
        self.log('%s: %d' % (word, self.counts[word]))
