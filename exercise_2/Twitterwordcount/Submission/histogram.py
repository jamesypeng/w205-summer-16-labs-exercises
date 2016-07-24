import psycopg2
import sys
import getopt

if len(sys.argv) != 3:
    print('Usage: {} <min_count> <max_count>'.format('histogram') )
    sys.exit()
    
conn = psycopg2.connect(database="tcount", user="w205", password="postgres", host="54.227.25.254", port="5432")
min_cnt = sys.argv[1]
max_cnt = sys.argv[2]
full_qeury = True

    
query_string = "SELECT word, count FROM Tweetwordcount WHERE count >= {} AND count <= {} ORDER BY count DESC".format(min_cnt, max_cnt)
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