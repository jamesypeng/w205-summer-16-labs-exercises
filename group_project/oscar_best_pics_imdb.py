# -*- coding: utf-8 -*-
import imdb 
import sqlalchemy
import pandas as pd
import numpy as np
import os

# #################################################3
ia = imdb.IMDb() 
oscar_dir = '/home/ubuntu/GitRepo'
oscar_file = 'oscar_best_pictures.csv'            
# convert the list to data frame

best_pics = pd.read_csv( os.path.join(oscar_dir, oscar_file) )


attr_list = [ 'title', 'genres', 'year', 'countries', 'cast']
#attr_list = [ 'genres', 'year', 'countries', 'cast']

info_list = ['business','vote details']

vote_columns = { 'rating': 'rating',
                 'number of votes': ['R1', 'R2', 'R3', 'R4','R5','R6','R7','R8', 'R9', 'R10'],
                 'demographic': ['males', 'females',  
                                 'aged under 18', 'males under 18', 'females under 18',  
                                 'aged 18-29', 'males aged 18-29', 'females aged 18-29',  
                                 'aged 30-44', 'males aged 30-44', 'females aged 30-44',  
                                 'aged 45+', 'males aged 45+', 'females aged 45+',  
                                 'imdb staff', 'top 1000 voters',  
                                 'us users','non-us users', 
                                 'IMDb users']
                 }
cast_columns = ['cast0','cast1','cast2','cast3']

for attr in attr_list:
    best_pics[attr] = unicode("")

for info in info_list:
    best_pics[info] = unicode("")


for k,v in vote_columns.items():   
    if isinstance(v,list):
        for j in v:
            best_pics[j] = unicode("")       
    else:
        best_pics[v] = unicode("") 

# select top 4 actors     
for c in cast_columns:
    best_pics[c] = unicode("")
    

start = 0
end = len( best_pics )
#end = 57

for i in range( start,end ):    
    title = best_pics['Film'][i]
    print(title)
    
    value = list()  
    s_result = ia.search_movie(title) 
    
    for j in range(0,len(s_result)): 
        m = s_result[j] 
        ia.update(m) 
        if m.has_key('year') == False:
            continue
        # In the beginining the year index is shown as 1927/28
        # we compare the current year and previous year
        if ( m['year'] ==  best_pics['winning_year'][i] or m['year'] ==  best_pics['winning_year'][i]-1 ):
            print '"',title,'"','updated! Winning Year:', best_pics['winning_year'][i], m['year']
  
            print(title,'year')
            for attr in attr_list:
                if m.has_key(attr) == True: 
                    if( attr != 'cast'):
                        best_pics.loc[i,attr] = json.dumps(m[attr]) #unicode(m[attr]).encode('utf-8') 
                        #best_pics[attr][i] = str(m[attr])   
                        value.append(m[attr])
                    else:
                        # cast info
                        p_idx = 0;
                        for p in m['cast'][0:4]:
                            ia.update(p)
                            
                            col = 'cast'+str(p_idx)
                            p_idx = p_idx +1
                            if p.has_key('actress') == True:
                                cast_name = '("' + p['name'] + '":"female"' + ')'
                    
                                
                            else: 
                                cast_name ='("' + p['name']+'":"male"' + ')' 
                            print(cast_name)
                            #best_pics[col][i] = cast_name
                            best_pics.loc[i,col] = unicode(cast_name).encode('utf-8') 
            ia.update(m, info=(info_list)) 
            # get the business data  
            info = 'business'
            print(title,info)
            if m.has_key(info) == True:
                #best_pics[info][i] = str(m[info]) 
                #best_pics.loc[i,info] = unicode(m[info]).encode('utf-8') 
                best_pics.loc[i,info] = json.dumps(m[info])                 
                value.append(m[info])
                
            info = 'rating'
            print(title,info)
            if m.has_key(info) == True:
                #best_pics[info][i] = str(m[info]) 
                best_pics.loc[i,info] = unicode(m[info]).encode('utf-8') 
                value.append(m[info])
            info = 'number of votes'                
            if m.has_key(info) == True:
                number_votes = m['number of votes'] 
                for r in xrange(1, 11):  
                    col = 'R'+str(r)
                    #best_pics[col][i] =  str(number_votes[r]) 
                    best_pics.loc[i,col] = unicode(number_votes[r]) .encode('utf-8') 
                    value.append(number_votes[r] )
            info = 'demographic' 
            if m.has_key(info) == True:  
                print 'get demographic' 
                demo_info = vote_columns[info]
                demo_value = m[info]  
                for in_fo in demo_info:  
                    if demo_value.get(in_fo) != None:  
                        #best_pics[in_fo][i] =  str(demo_value.get(in_fo)) 
                        best_pics.loc[i,in_fo] = unicode(demo_value.get(in_fo)).encode('utf-8') 
                        value.append(number_votes[r] )
                        # print in_fo, demo_value.get(in_fo)[0], demo_value.get(in_fo)[1]  
            print(value)
            break
        else:
            print(title, best_pics['winning_year'][i], m['year'])

best_pics.to_csv(os.path.join(oscar_dir, 'best_pics_imdb.csv'), 
                sep=",", na_rep='', float_format=None, 
                columns=None, header=True, index=True, 
                index_label=None, mode='w', encoding=None, 
                compression=None, quoting=None, 
                quotechar='"', line_terminator='\n', 
                chunksize=None, tupleize_cols=False, 
                date_format=None, doublequote=True, 
                escapechar=None, decimal='.')

# ################


#oscar_movies = pd.read_csv('/home/ubuntu/GitRepo/oscar_movies.csv')

#mysql_ip = '52.204.66.2'  
#mysql_user = 'ucb_user'  
#mysql_passwd = 'ucb_user'  
#mysql_db = 'imdb'  

#mysql_list = ['mysql://', mysql_user, ':', mysql_passwd, '@', mysql_ip, '/', mysql_db] 
#mysql_uri = ''.join(mysql_list)


##i = IMDb('sql', uri='sqlite:/home/user/random/mov.db', useORM='sqlalchemy,sqlobject')
## mysql://user:password@localhost/imdb
## http://www.imdb.com/search/title?count=1000&groups=oscar_winners,oscar_nominees&title_type=feature&sort=year,desc&view=simple


#def imdb_voting():  
    #title = "12 Years a Slave"  
    #ia = imdb.IMDb()  
    #print 'Connect to mysql'
    ##ia = imdb.IMDb('sql', uri=mysql_uri)
    
    #s_result = ia.search_movie(title)  
    #'''  
    #for item in s_result:  
        #print item['title']  
    #'''  
    #the_unt = s_result[0]  
    #ia.update(the_unt, info=('vote details'))  

    #if the_unt.has_key('rating'):  
        #print the_unt['rating']  
    #if the_unt.has_key('number of votes'):  
        #number_votes = the_unt['number of votes']  
        #for r in xrange(1, 11):  
            #print 'R'+str(r), number_votes[r]  
    #if the_unt.has_key('demographic'):  
        #infos = [  
            #'males', 'females',  
            #'aged under 18', 'males under 18', 'females under 18',  
            #'aged 18-29', 'males aged 18-29', 'females aged 18-29',  
            #'aged 30-44', 'males aged 30-44', 'females aged 30-44',  
            #'aged 45+', 'males aged 45+', 'females aged 45+',  
            #'imdb staff', 'top 1000 voters',  
            #'us users','non-us users' 
            #'Iimdb users'
        #]  
        
        #demo_value = the_unt['demographic']  
        #print 'get demographic'  
        #for in_fo in infos:  
            #if demo_value.get(in_fo) != None:  
                #print in_fo, demo_value.get(in_fo)[0], demo_value.get(in_fo)[1]

## get oscar movie list

##def imdb_search_oscar():
    ##ihttp = imdb.IMDb('http')  
    ##print 'Connect to IMDB website'
    
    ##s_result = ia.search_keyword(u'oscar')    
    ##print s_result
                
##########################################33
    
#oscar_dir = '/home/ubuntu/GitRepo'
#oscar_file = 'oscar_best_pictures.csv'            
## convert the list to data frame

#best_pics = pd.read_csv( os.path.join(oscar_dir, oscar_file) )




#ia = imdb.IMDb()  
                
#title = "Stutterer"
#title = 'Birdman'
##title = "12 Years a Slave" 

##ia = imdb.IMDb('sql', uri=mysql_uri)

#s_result = ia.search_movie(title)  
#'''  
#for item in s_result:  
    #print item['title']  
#'''  
#the_unt = s_result[0]  
#ia.update(the_unt) # get all information
#the_unt.summary()

#the_unt['title']
#the_unt['genres']
#the_unt['year']
#the_unt['countries']
#the_unt['cast']

## this two keys are aliased to 'cast'
##the_unt['actors']
##the_unt['actresses']


#m_info = ['release dates', 'business', 'vote details']

#ia.update(the_unt, info=(m_info))

#for i in m_info: 
    #print("--------------------------- {0}  -----------------------------------------".format(i) )
    #the_unt[i]

#the_unt['business']['gross']
#the_unt['business']['charts & trends']


#for p in the_unt['cast'][0:4]:
    #ia.update(p)
    #if p.has_key('actress') == True:
        #print(p['name'], 'female')
    #else: 
        #print(p['name'], 'male')


#the_unt['cast'][0:3]
#p = the_unt['cast'][0]
#ia.update(p)
#p.summary()
#p['name']
#p.has_key('actress')



            