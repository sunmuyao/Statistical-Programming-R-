#read packages
library(rvest)
library(stringr)
library(tibble)
library(dplyr)
library(methods)

files = dir("data/lq/", "html", full.names = TRUE)    #collect all files with full path from lq folder

res = list()   #create an empty list

for(i in seq_along(files))
{
  file = files[i]    #use file object to iterate through the files     
  
  page = read_html(file)   #read html data from file and save it to page
  
  hotel_info = page %>% 
    html_nodes(".hotelDetailsBasicInfoTitle p") %>%   #read the hotel information selected by css selector
    html_text() %>%      #extract tag pairs’ content
    str_split("\n") %>%  #change all "\n" to " "
    .[[1]] %>% 
    str_trim() %>%       #trim whitespace from start and end of string 
    .[. != ""]           #remove all ""
  
  location_name = page %>% html_nodes("h1") %>% #read the hotel name selected by css selector
    html_text() %>%     #extract tag pairs’ content
    str_trim()         #trim whitespace from start and end of string 
  
  n_rooms = page %>% 
    html_nodes(".hotelFeatureList li:nth-child(2)") %>% #read the number of rooms selected by css selector
    html_text() %>%                                     #extract tag pairs’ content
    str_trim() %>%                                      #trim whitespace from start and end of string 
    str_replace("Rooms: ", "") %>%                      #replaces the string "Rooms: " by string ""
    as.integer()                                        #make it as an integer type
  
  features = page %>%
    html_nodes(".pptab_contentL li") %>%  #read the feature of hotels selected by css selector
    html_text() %>%                       #extract tag pairs’ content
    paste(collapse=" ")
  
  swim = features %>% str_detect("Swimming Pool")       #swimming pools
  internet = features %>% str_detect("Internet")        #internet availability
  
  floors = page %>%                                     
    html_nodes(".hotelFeatureList li:nth-child(1)") %>%  #read the floor of rooms selected by css selector
    html_text() %>%                                      #extract tag pairs’ content
    str_replace("Floors:","") %>%                        #replaces the string "Floors: " by string ""
    as.numeric()                                         #make it as an numeric type
  
  # Google link includes latitude first then longitude
  lat_long = page %>%
    html_nodes(".minimap") %>%                  #read the location of hotels selected by css selector
    html_attr("src") %>%                        #extract tags’ attribute "scr"
    #match string to regular expression for Geographic coordinate system
    str_match("\\|(-?[0-9]{1,2}\\.[0-9]+),(-?[0-9]{1,3}\\.[0-9]+)&")   
  
  
  res[[i]] = data_frame(    
    location_name = location_name,                 #hotel names is first column of dataframe
    address = paste(hotel_info[1:2],collapse="\n"),     #address is second column of dataframe
    phone = hotel_info[3] %>% str_replace("Phone: ", ""),  #phone is third column of dataframe
    fax   = hotel_info[4] %>% str_replace("Fax: ", ""),    #fax is fourth column of dataframe
    n_rooms = n_rooms,                                 #number of rooms is fifth column of dataframe
    swimming_pool = ifelse(swim==TRUE,"Yes","No"),    #swimming pool is sixth column of dataframe
    internet = ifelse(internet==TRUE,"Yes","No"),    #internet is seventh column of dataframe
    floors,                                        #floors is eigth column of dataframe
    lat   = lat_long[,2],                         #latitude is ninth column of dataframe
    long  = lat_long[,3]                         #longitude is tenth column of dataframe
  )
  
  #regular expression for US and Cananian telephone number
  validate ="^([0-9]( |-)?)?(\\(?[0-9]{3}\\)?|[0-9]{3})( |-)?([0-9]{3}( |-)?[0-9]{4}|[a-zA-Z0-9]{7})$"
  
  #test whether string match to regular expression for US and Cananian telephone number
  if(str_detect(res[[i]]$phone,validate) == FALSE)  
  {
    res[[i]]$phone = NA    #if not match, set corresponding position as NA
  }
  
  #regular expression for US zipcode
  validate1 ="[0-9]{5}(-[0-9]{4})?(?!.*[0-9]{5}(-[0-9]{4})?)"
  
  #test whether string match to regular expression for US zipcode
  if(str_detect(res[[i]]$address,validate1) == FALSE)
  {
    res[[i]]$phone = NA    #if not match, set corresponding position as NA
  }
}
hotels = bind_rows(res)    #bind all rows together
hotels = na.omit(hotels)   #remove all rows containing NA value

dir.create("data/", showWarnings = FALSE)   
save(hotels, file="data/lq.Rdata")           #save the dataframe hotels as lq.Rdata in data folder