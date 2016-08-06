### 1.  Provide a screenshot of the output from the Spark Streaming process.

![alternate text](./1-2016-08-06_18-08-49.png)

### 2: Change the code so that you save the venue components to a text file. Submit you code

```{python}
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
```

```
```


### 3: Provide a screenshot showing the running Spark Streaming application

![alternate text](./3-2016-08-06_19-11-01.png)

### 4a: Provide a screenshot of the running Spark Streaming application that shows that the CountByWindow indeed provides an sum of the counts from the 3 latest batches. See example screenshot below


*I use the log instead*

```
-------------------------------------------
Time: 2016-08-06 11:24:50
-------------------------------------------
46

-------------------------------------------
Time: 2016-08-06 11:24:50
-------------------------------------------
14

-------------------------------------------
Time: 2016-08-06 11:24:50
-------------------------------------------
12

-------------------------------------------
Time: 2016-08-06 11:24:50
-------------------------------------------
{u'lat': 33.492311000000001, u'venue_id': 1294004, u'lon': -84.558589999999995, u'venue_name': u'Partners II Pizza'}
{u'lat': 53.564399999999999, u'venue_id': 24550762, u'lon': 9.9202700000000004, u'venue_name': u'jimdo Haus'}
{u'lat': 46.773902999999997, u'venue_id': 24369037, u'lon': 23.599454999999999, u'venue_name': u'ClujHub'}
{u'lat': 26.317739, u'venue_id': 9168942, u'lon': -80.157982000000004, u'venue_name': u'Panera Bread'}
{u'lat': 29.742263999999999, u'venue_id': 24199587, u'lon': -95.377135999999993, u'venue_name': u'HCC Conference Center'}
{u'lat': 35.855732000000003, u'venue_id': 24686226, u'lon': -78.669753999999998, u'venue_name': u'Elks Lodge Ballroom'}
{u'lat': 39.729343, u'venue_id': 16145292, u'lon': -75.561667999999997, u'venue_name': u"Timothy's on the Wilmington Riverfront (Shipyard Shops"}
{u'lat': 41.399245999999998, u'venue_id': 11787332, u'lon': 2.1612930000000001, u'venue_name': u'Dioclub'}
{u'lat': 40.894813999999997, u'venue_id': 10712892, u'lon': -73.098906999999997, u'venue_name': u'Espana Tapas and Wine Bar'}
{u'lat': 12.942117, u'venue_id': 24247141, u'lon': 77.575362999999996, u'venue_name': u'Fralk - 3rd floor , Aishwarya sampoorna '}
...

16/08/06 11:24:51 WARN BlockManager: Block input-0-1470482691400 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:24:53 WARN BlockManager: Block input-0-1470482693000 replicated to only 0 peer(s) instead of 1 peers
-------------------------------------------
Time: 2016-08-06 11:25:00
-------------------------------------------
32

-------------------------------------------
Time: 2016-08-06 11:25:00
-------------------------------------------
6

-------------------------------------------
Time: 2016-08-06 11:25:00
-------------------------------------------
5

-------------------------------------------
Time: 2016-08-06 11:25:00
-------------------------------------------
{u'lat': 39.170921, u'venue_id': 24270593, u'lon': -77.262611000000007, u'venue_name': u'Pack Place K9'}
{u'lat': 40.800097999999998, u'venue_id': 744924, u'lon': -74.481605999999999, u'venue_name': u'Pazzo Pazzo'}
{u'lat': 45.101913000000003, u'venue_id': 24504546, u'lon': -93.441299000000001, u'venue_name': u'Maple Grove Public Library, Training Room 133'}
{u'lat': 41.438094999999997, u'venue_id': 24695838, u'lon': -71.452881000000005, u'venue_name': u'Narragansett Beach south lot'}
{u'lat': 35.227085000000002, u'venue_id': 24591436, u'lon': -80.843124000000003, u'venue_name': u'Frog Song Farm'}

16/08/06 11:25:01 WARN BlockManager: Block input-0-1470482701200 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:02 WARN BlockManager: Block input-0-1470482702000 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:04 WARN BlockManager: Block input-0-1470482704400 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:08 WARN BlockManager: Block input-0-1470482707800 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:10 WARN BlockManager: Block input-0-1470482709800 replicated to only 0 peer(s) instead of 1 peers
-------------------------------------------
Time: 2016-08-06 11:25:10
-------------------------------------------
31

-------------------------------------------
Time: 2016-08-06 11:25:10
-------------------------------------------
11

-------------------------------------------
Time: 2016-08-06 11:25:10
-------------------------------------------
8

-------------------------------------------
Time: 2016-08-06 11:25:10
-------------------------------------------
{u'lat': 12.942117, u'venue_id': 24247141, u'lon': 77.575362999999996, u'venue_name': u'Fralk - 3rd floor , Aishwarya sampoorna '}
{u'lat': 0, u'venue_id': 23896302, u'lon': 0, u'venue_name': u'AMC Joe Dodge Lodge at Pinkham Notch'}
{u'lat': 41.399245999999998, u'venue_id': 11787332, u'lon': 2.1612930000000001, u'venue_name': u'Dioclub'}
{u'lat': 40.419894999999997, u'venue_id': 22424542, u'lon': -3.6891050000000001, u'venue_name': u'Parque del Retiro, Puerta de la Independencia (Puerta de Alcal\xe1)'}
{u'lat': 44.544960000000003, u'venue_id': 1971671, u'lon': -72.527379999999994, u'venue_name': u'Elmore State Park '}
{u'lat': 35.171658000000001, u'venue_id': 24303615, u'lon': -80.879326000000006, u'venue_name': u'Three Spirits Brewery'}
{u'lat': 43.653182999999999, u'venue_id': 9959682, u'lon': -116.25588999999999, u'venue_name': u'The Drink'}
{u'lat': -26.389091000000001, u'venue_id': 24646184, u'lon': 153.092285, u'venue_name': u'Halse lodge '}

16/08/06 11:25:14 WARN BlockManager: Block input-0-1470482714000 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:17 WARN BlockManager: Block input-0-1470482717200 replicated to only 0 peer(s) instead of 1 peers
-------------------------------------------
Time: 2016-08-06 11:25:20
-------------------------------------------
26

-------------------------------------------
Time: 2016-08-06 11:25:20
-------------------------------------------
9

16/08/06 11:25:20 WARN BlockManager: Block input-0-1470482720600 replicated to only 0 peer(s) instead of 1 peers
-------------------------------------------
Time: 2016-08-06 11:25:20
-------------------------------------------
8

-------------------------------------------
Time: 2016-08-06 11:25:20
-------------------------------------------
{u'lat': 40.419894999999997, u'venue_id': 22424542, u'lon': -3.6891050000000001, u'venue_name': u'Parque del Retiro, Puerta de la Independencia (Puerta de Alcal\xe1)'}
{u'lat': 35.709026000000001, u'venue_id': 24260160, u'lon': 139.73199500000001, u'venue_name': u'Hub Ikebukuro East Annex'}
{u'lat': 0, u'venue_id': 24640953, u'lon': 0, u'venue_name': u'Starbucks'}
{u'lat': 38.863742999999999, u'venue_id': 369626, u'lon': -77.379850000000005, u'venue_name': u'SRA Volleyball Courts'}
{u'lat': 51.444893, u'venue_id': 4984702, u'lon': -0.20629500000000001, u'venue_name': u'Wimbledon Park Tennis Courts'}
{u'lat': -26.389091000000001, u'venue_id': 24646184, u'lon': 153.092285, u'venue_name': u'Halse lodge '}
{u'lat': 40.316524999999999, u'venue_id': 24383294, u'lon': -74.845000999999996, u'venue_name': u'40.29764, -74.86834 '}
{u'lat': 41.075321000000002, u'venue_id': 24697898, u'lon': -75.434325999999999, u'venue_name': u'Pocono Raceway'}

16/08/06 11:25:24 WARN BlockManager: Block input-0-1470482724200 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:28 WARN BlockManager: Block input-0-1470482728200 replicated to only 0 peer(s) instead of 1 peers
16/08/06 11:25:29 WARN BlockManager: Block input-0-1470482729600 replicated to only 0 peer(s) instead of 1 peers
-------------------------------------------
Time: 2016-08-06 11:25:30
-------------------------------------------
31

-------------------------------------------
Time: 2016-08-06 11:25:30
-------------------------------------------
11

-------------------------------------------
Time: 2016-08-06 11:25:30
-------------------------------------------
9

-------------------------------------------
Time: 2016-08-06 11:25:30
-------------------------------------------
{u'lat': 39.006774999999998, u'venue_id': 24702528, u'lon': -76.779137000000006, u'venue_name': u"Kamise's House!"}
{u'lat': 51.506850999999997, u'venue_id': 3500822, u'lon': -0.142927, u'venue_name': u'Green Park'}
{u'lat': 47.886372000000001, u'venue_id': 24695607, u'lon': 8.9075299999999995, u'venue_name': u'Sufi Zentrum Rabbaniyya - Der Wahre Mensch e.V.'}
{u'lat': 51.506850999999997, u'venue_id': 3500822, u'lon': -0.142927, u'venue_name': u'Green Park'}
{u'lat': 40.511406000000001, u'venue_id': 24659054, u'lon': -74.661086999999995, u'venue_name': u'iconic.yoga@gmail.com'}
{u'lat': 47.886372000000001, u'venue_id': 24695607, u'lon': 8.9075299999999995, u'venue_name': u'Sufi Zentrum Rabbaniyya - Der Wahre Mensch e.V.'}
{u'lat': 42.495086999999998, u'venue_id': 3342822, u'lon': -71.123649999999998, u'venue_name': u"Sal's Pizza"}
{u'lat': 1.249404, u'venue_id': 9623922, u'lon': 103.830322, u'venue_name': u'Palawan Beach, Sentosa Island'}
{u'lat': 1.30088, u'venue_id': 23904219, u'lon': 103.87416, u'venue_name': u'Sports Hub @ OCBC Arena - Hall 3'}
```
### 4b: Also explain what the difference is between having 10 sec batches with a 30 sec sliding window and a 30 second batch length.

> In 30 second batch length, the sliding window will only count the current batch data.  
> In 10 second batch length, the sliding window will count the current plus last 2 batches.   