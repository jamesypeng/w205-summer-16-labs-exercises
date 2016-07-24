import psycopg2
import sys

full_qeury = False
conn = psycopg2.connect(database="tcount", user="w205", password="postgres", host="54.227.25.254", port="5432")

if len(sys.argv) > 1:
    words_list = list(map(lambda x : "'" + x + "'", (sys.argv[1:])))
    words_string = ",".join(words_list)
    query_string = "SELECT word, count FROM Tweetwordcount WHERE word in ({}) ORDER BY count DESC".format(words_string)
else:
    query_string = "SELECT word, count FROM Tweetwordcount ORDER BY word ASC"
    full_qeury = True
    

cur = conn.cursor()

cur.execute(query_string)
            
records = cur.fetchall()

for rec in records:
    if full_qeury == True:
        print('("%s": %d)' %(rec[0], rec[1]) )
    else:
        print('Total number of occurences of "%s": %d' %(rec[0], rec[1]) )
    
conn.commit()

conn.close()