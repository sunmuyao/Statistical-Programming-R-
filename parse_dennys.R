library(rvest)   #read packages
library(stringr)
library(tibble)
library(dplyr)
library(methods)

de.files = dir("data/dennys/", "xml", full.names = TRUE)    #collect all relative paths in dennys folder
dennys = list()   #create an empty list
for(i in seq_along(de.files)){    #iteration over each xml files inside
  file = de.files[i]    #create a temporary file named file in each iteration
  
  dennys_info = read_html(file)   #read xml data from file and save it to dennys_info
  
  location_name = dennys_info %>%   #retrieve the information of location_names for all Dennys
    html_nodes("name") %>% 
    html_text() %>% 
    str_trim()
  address = dennys_info %>%     #retrieve the information of address for all Dennys
    html_nodes("address1") %>% 
    html_text() %>% 
    str_trim()
  zipcode = dennys_info %>% 
    html_nodes("postalcode") %>%     #retrieve the information of zip code for all Dennys
    html_text() %>% 
    str_trim()
  city = dennys_info %>%     #retrieve the information of city for all Dennys
    html_nodes("city") %>% 
    html_text() %>% 
    str_trim()
  state = dennys_info %>%    #retrieve the information of state for all Dennys
    html_nodes("state") %>% 
    html_text() %>%
    str_trim()
  country = dennys_info %>%     #retrieve the information of country for all Dennys
    html_nodes("country") %>% 
    html_text() %>%
    str_trim()
  latitude = dennys_info %>%    #retrieve the information of latitude for all Dennys
    html_nodes("latitude") %>% 
    html_text() %>% 
    str_trim()
  longitude = dennys_info %>%    #retrieve the information of longitude for all Dennys
    html_nodes("longitude") %>% 
    html_text() %>% 
    str_trim()
  phone = dennys_info %>%    #retrieve the information of phone number for all Dennys
    html_nodes("phone") %>% 
    html_text() %>% 
    str_trim()
  
  res = list()    #create an empty list
  for(j in seq_along(address))
  {
    res[[j]] = data_frame(    # each list contains a dataframe
      location_name = location_name[j],     #location names is first column of dataframe
      address = paste(address[j],city[j], paste(state[j],zipcode[j]), sep =", \n"),    #address is second column of dataframe
      country = country[j],   #country is third column of dataframe
      phone = phone[j],      #phone number is fourth column of dataframe
      lat = latitude[j],    #latitude is fifth column of dataframe
      long = longitude[j]    #longitude is sixth column of dataframe
    )
  }
  dennys <- union(dennys, res)   #get the unique information of dennys
}
dennys = bind_rows(dennys)     #bind all rows together

dennys.US <- dennys %>%   #filter out the dennys only in the US
  filter(dennys$country == "US")


save(dennys.US,file="data/dennys.Rdata")     #save the files to data/dennys