# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import sys
import os
import logging
import logging.handlers
import requests
import pymysql  
import pandas as pd
import numpy as np
import re
import csv
import platform

def scrape(url, output_name, begin_index = None):
    """Create CSVs from all tables in a Wikipedia article.

    ARGS:
        url (str): The full URL of the Wikipedia article to scrape tables from.
        output_name (str): The base file name (without filepath) to write to.
    """

    # Read tables from Wikipedia article into list of HTML strings
    resp = requests.get(url)
    soup = BeautifulSoup(resp.text, 'lxml')
    table_classes = {"class": "wikitable"}
    wikitables = soup.findAll("table", table_classes)

    # Create folder for output if it doesn't exist
    try:
        os.mkdir(output_name)
    except Exception:  # Generic OS Error
        pass

    for index, table in enumerate(wikitables):
        # Make a unique file name for each CSV
        if index == 0:
            if begin_index == None:
                filename = output_name
            else: 
               filename = output_name + '_' + str(index+begin_index)
        else:
            
            if begin_index == None:
                filename = output_name + '_' + str(index)
            else: 
               filename = output_name + '_' + str(index+begin_index)            

        filepath = os.path.join(output_name, filename) + '.csv'

        with open(filepath, mode='w', newline='', encoding='utf-8') as output:
            # Deal with Windows inserting an extra '\r' in line terminators
            if platform.system() == 'Windows':
                kwargs = {'lineterminator': '\n'}

            csv_writer = csv.writer(output, quoting=csv.QUOTE_ALL, **kwargs)
            write_html_table_to_csv(table, csv_writer)


def write_html_table_to_csv(table, writer):
    """Write HTML table from Wikipedia to a CSV file.

    ARGS:
        table (bs4.Tag): The bs4 Tag object being analyzed.
        writer (csv.writer): The csv Writer object creating the output.
    """

    # Hold elements that span multiple rows in a list of
    # dictionaries that track 'rows_left' and 'value'
    saved_rowspans = []
    for row in table.findAll("tr"):
        cells = row.findAll(["th", "td"])

        # If the first row, use it to define width of table
        if len(saved_rowspans) == 0:
            saved_rowspans = [None for _ in cells]
        # Insert values from cells that span into this row
        elif len(cells) != len(saved_rowspans):
            for index, rowspan_data in enumerate(saved_rowspans):
                if rowspan_data is not None:
                    # Insert the data from previous row; decrement rows left
                    value = rowspan_data['value']
                    cells.insert(index, value)

                    if saved_rowspans[index]['rows_left'] == 1:
                        saved_rowspans[index] = None
                    else:
                        saved_rowspans[index]['rows_left'] -= 1

        # If an element with rowspan, save it for future cells
        for index, cell in enumerate(cells):
            if cell.has_attr("rowspan"):
                rowspan_data = {
                    'rows_left': int(cell["rowspan"]),
                    'value': cell,
                }
                saved_rowspans[index] = rowspan_data

        if cells:
            # Clean the data of references and unusual whitespace
            cleaned = clean_data(cells)

            # Fill the row with empty columns if some are missing
            # (Some HTML tables leave final empty cells without a <td> tag)
            columns_missing = len(saved_rowspans) - len(cleaned)
            if columns_missing:
                cleaned += [None] * columns_missing

            writer.writerow(cleaned)


def clean_data(row):
    """Clean table row list from Wikipedia into a string for CSV.

    ARGS:
        row (bs4.ResultSet): The bs4 result set being cleaned for output.

    RETURNS:
        cleaned_cells (list[str]): List of cleaned text items in this row.
    """

    cleaned_cells = []

    for cell in row:
        # Strip references from the cell
        references = cell.findAll("sup", {"class": "reference"})
        if references:
            for ref in references:
                ref.extract()

        # Strip sortkeys from the cell
        sortkeys = cell.findAll("span", {"class": "sortkey"})
        if sortkeys:
            for ref in sortkeys:
                ref.extract()

        # Strip footnotes from text and join into a single string
        text_items = cell.findAll(text=True)
        no_footnotes = [text for text in text_items if text[0] != '[']

        cleaned = (
            ''.join(no_footnotes)  # Combine elements into single string
            .replace('\xa0', ' ')  # Replace non-breaking spaces
            .replace('\n', ' ')  # Replace newlines
            .strip()
        )

        cleaned_cells += [cleaned]

    return cleaned_cells

class OscarMovies:
    def __init__(self,logger):
        self.url = None
        self.logger = logger
        self.status = None
        self.session = None
        
        self.winner_list = list ()
        self.nominated_list = list ()
        
        user = 'ucb_user'
        pw = 'ucb_user'
        host = '52.204.66.2'
        port = 3306
        
        self.conn = pymysql.connect(db='imdb', user=user, passwd=pw, host=host, port=3306) 
    
        
    def get_url(self,url):
        session = requests.session()
        r = session.get(url)       
        
        self.status = r.status_code  
        print(self.status)
        self.logger.info(self.status)    
        
        
        
        return r.text
    
    def get_movie_list(self, winner = True): 
        
        if winner == True:
            url = "http://www.imdb.com/search/title?count=10000&groups=oscar_winners&title_type=feature&sort=year,desc&view=simple"
        else:
            url = "http://www.imdb.com/search/title?count=10000&groups=oscar_nominees&title_type=feature&sort=year,desc&view=simple"
        # url = "https://en.wikipedia.org/wiki/List_of_Academy_Award-winning_films"
    
        html = self.get_url(url)
        soup = BeautifulSoup(html, "lxml")  
        
        span_list = soup.findAll("span", { "class" : "lister-item-header" })
        title_list = soup.find_all(href=re.compile("/title/tt.*\?ref_=adv_li_tt"))
        year_list = soup.findAll("span", { "class" : "lister-item-year text-muted unbold" })
        
        oscar_list = list()
        for i in range(0, len(title_list)):
            
            title = re.sub('<.*?>', "", str(title_list[i]))
            year = re.sub('<.*?>', "", str(year_list[i]))
            year = re.sub('[a-zA-Z]|\s|\(|\)', '', year)
            
            d = {'title': title, 'year': year}
            oscar_list.append(d)
        
        if winner == True:
            self.winner_list = oscar_list
        else:
            self.nominated_list = oscar_list
        
    
        
    def UpdateDb(self):
        cur = self.conn.cursor()
        for i in range(0,len(self.oscar_list)): 
            update_str = 'INSERT INTO oscar_movie(title,year) VALUES ("{0}",{1})'.format( self.oscar_list[i]['title'], 
                                                                                            self.oscar_list[i]['year'])
            cur.execute(update_str)
            self.conn.commit()
        
        #self.conn.commit()            
 
scrape("https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture", output_name="c:\\temp\\films-best", begin_index = 1928)   

        
scrape("https://en.wikipedia.org/wiki/List_of_Academy_Award-winning_films", output_name="c:\\temp\\films-winning")       
        
LOG_FILE='c:\\temp\\analysis\\oscar.log'

handler=logging.handlers.RotatingFileHandler(LOG_FILE,maxBytes=1024*1024,backupCount=5)
fmt = "%(asctime)s - %(filename)s: %(lineno)s - %(name)s - %(message)s"

logger=logging.getLogger('oscar')
logger.addHandler(handler)
#Logger.setLevel(lvl)

#log level ：NOTSET < DEBUG < INFO < WARNING < ERROR < CRITICAL
# logger.debug(""), warning(""), error(""), critical("")
logger.setLevel(logging.DEBUG)

#logger.info('first info message')
#logger.debug('first debug message')
#logger = logging
#logger.basicConfig(filename = os.path.join(os.getcwd(), 'log.txt'), #level = logging.DEBUG,
# filemode = 'w', format = '%(asctime)s - %(levelname)s: %(message)s')
oscar = OscarMovies(logger)

oscar.GetList()
oscar.UpdateDb()



