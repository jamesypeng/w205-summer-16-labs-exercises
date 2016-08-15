#!/usr/bin/env python  
# -*- coding: utf-8 -*-  

import subprocess  
import os  
import imdb  

location = './dbfiles'  
csv_location = './csvfiles'
    
imdb_script = './alberanid-imdbpy-398c01b96107/bin/imdbpy2sql.py'  
base_download_url = 'ftp://ftp.fu-berlin.de/pub/misc/movies/database/'  
to_download_files = [  
    #'movie-links.list.gz', 'keywords.list.gz', 'directors.list.gz',  
    #'editors.list.gz', 'genres.list.gz', 'language.list.gz',  
    #'movies.list.gz', 'producers.list.gz', 'production-companies.list.gz', 'ratings.list.gz',  
    #'writers.list.gz', 'countries.list.gz', 'complete-cast.list.gz',
    #'actors.list.gz','actresses.list.gz','composers.list.gz',
    #'distributors.list.gz', 'miscellaneous-companies.list.gz',
    #'special-effects-companies.list.gz','cinematographers.list.gz',
    #'composers.list.gz'
    
    'actors.list.gz',
    'actresses.list.gz',
    'aka-names.list.gz',
    'aka-titles.list.gz',
    #'alternate-versions.list.gz',
    #'biographies.list.gz',
    'business.list.gz',
    #'certificates.list.gz',
    'cinematographers.list.gz',
    #'color-info.list.gz',
    'complete-cast.list.gz',
    'complete-crew.list.gz',
    'composers.list.gz',
    'costume-designers.list.gz',
    'countries.list.gz',
    #'crazy-credits.list.gz',
    'directors.list.gz',
    'distributors.list.gz',
    'editors.list.gz',
    #'filesizes',
    #'filesizes.old',
    'genres.list.gz',
    #'german-aka-titles.list.gz',
    #'goofs.list.gz',
    #'iso-aka-titles.list.gz',
    #'italian-aka-titles.list.gz',
    'keywords.list.gz',
    'language.list.gz',
    #'laserdisc.list.gz',
    #'literature.list.gz',
    'locations.list.gz',
    'miscellaneous-companies.list.gz',
    'miscellaneous.list.gz',
    'movie-links.list.gz',
    'movies.list.gz',
    'mpaa-ratings-reasons.list.gz',
    #'plot.list.gz',
    'producers.list.gz',
    'production-companies.list.gz',
    #'production-designers.list.gz',
    #'quotes.list.gz',
    'ratings.list.gz',
    'release-dates.list.gz',
    'running-times.list.gz',
    #'sound-mix.list.gz',
    #'soundtracks.list.gz',
    'special-effects-companies.list.gz',
    'taglines.list.gz',
    'technical.list.gz',
    #'trivia.list.gz',
    'writers.list.gz'
   
]  

mysql_ip = 'localhost'  
mysql_user = 'root'  
mysql_passwd = 'Dmall28'  
mysql_db = 'imdb'  

def download_db_files():  
    for file in to_download_files:  
        url = base_download_url + file  
        print 'Downloading ', url  
        args = ['wget','-N', '-P', location, url]  
        t_pro = subprocess.Popen(args)  
        # block model too slow  
        t_pro.wait()  


def trans_db_to_local(to_csv = False):  
    while True:  
        allDone = True  
        for file in to_download_files:  
            if not os.path.isfile(location + '/' + file):  
                print 'need file: ', location+file  
                allDone = False  
                break  
        if allDone == True:  
            break  

    print 'Running imdbpy2sql.py begin'  
    # mysql://user:password@host/database  
    mysql_list = ['mysql://', mysql_user, ':', mysql_passwd, '@', mysql_ip, '/', mysql_db]  
    
    if to_csv == False:
        print 'import to MySQL database'
        

        subprocess.call(imdb_script + ' -d ' + location + ' -u ' + 
                        ''.join(mysql_list) + ' --mysql-force-myisam', shell=True)  
    else:
        print 'import to CSV files'
        subprocess.call(imdb_script + ' -d ' + location + ' -u ' + 
                        ''.join(mysql_list) + ' --mysql-force-myisam' + 
                        ' -c ' + csv_location + ' --csv-ext .csv '
                      , shell=True)    
    
    print 'Running imdbpy2sql.py. over'  


def run():  
    #download_db_files()  
    trans_db_to_local( to_csv = False)  

if __name__ == '__main__':  
    run()