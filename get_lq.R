library(rvest)
library(stringr)
library(tibble)
library(dplyr)
library(methods)

site = "http://www2.stat.duke.edu/~cr173/lq_test/www.lq.com/en/findandbook/"
url = paste0(site,"hotel-listings.html")                        #get the url for each hotel

page = read_html(url)                                           #read La Quinta's hotel listings page

hotel_pages = page %>% 
  html_nodes("#hotelListing .col-sm-12 a") %>%                  #each La Quinta hotel link (relative address)
  html_attr("href") %>%                                         #extract tags’ attribute "href"
  .[!is.na(.)] %>%                                              #remove all rows containing NA value
  unique()                                                      #avoid duplication

dir.create("data/lq",recursive = TRUE,showWarnings = FALSE)     #create a directory 

for(hotel_page in hotel_pages)                                  #download from Internet
{
  hotel_url = paste0(site, hotel_page)                          #use absolute address
  download.file(url = hotel_url,      #a character string naming the URL of a resource to be downloaded
                destfile = file.path("data/lq",hotel_page),     #save the files to data/lq
                quiet = TRUE)
  print(hotel_page)
}

