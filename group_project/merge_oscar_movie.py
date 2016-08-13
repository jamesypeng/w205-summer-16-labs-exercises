import sys
import os
import requests
import pymysql  
import pandas as pd
import numpy as np
import re
import csv
import platform
import re

oscar_dir = "c:\\Users\\James\\SkyDrive\\Documents\\MIDS-Berkeley\\W205 Storing and Retrieving  Data\\w205-summer-16-labs-exercises\\group_project\\wiki_scrape"



oscar_list = list()

for root,dirs,files in os.walk(oscar_dir):
    for name in files:
        #print(os.path.join(root, name))
        print(name)
        year = re.search('(\d{4})', name)
        
        nominees = pd.read_csv( os.path.join(root, name) )
        
        for i in range(0,len(nominees)):
            
            if i == 0:
                best = 1
            else:
                best = 0
                
            title = dict({'Film': nominees['Film'][i],
                    'year': year.group(0),
                    'winning': best})
            oscar_list.append(title)

oscar_dir = 'c:\\temp\\'
oscar_file = 'oscar_best_pictures.csv'            
# convert the list to data frame
df_oscar = pd.DataFrame(oscar_list)

df_oscar.to_csv( os.path.join(oscar_dir, oscar_file), index_label = 'id' )

