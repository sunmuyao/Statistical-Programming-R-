library(rvest)

limit = 1000
zip_code = 27705
radius = 3000

get_url = function(limit, zip_code, radius)         #create the get_url function using limit, zip code and radius
{
  paste0(
    "https://hosted.where2getit.com/dennys/responsive/ajax?&xml_request=%3Crequest%3E%3Cappkey%3E6B962D40-03BA-11E5-BC31-9A51842CA48B%3C%2Fappkey%3E%3Cformdata+id%3D%22locatorsearch%22%3E%3Cdataview%3Estore_default%3C%2Fdataview%3E%3Climit%3E",
    limit,"%3C%2Flimit%3E%3Corder%3Erank%2C_distance%3C%2Forder%3E%3Cgeolocs%3E%3Cgeoloc%3E%3Caddressline%3E",
    zip_code,
    "%3C%2Faddressline%3E%3Clongitude%3E%3C%2Flongitude%3E%3Clatitude%3E%3C%2Flatitude%3E%3Ccountry%3EUS%3C%2Fcountry%3E%3C%2Fgeoloc%3E%3C%2Fgeolocs%3E%3Cstateonly%3E1%3C%2Fstateonly%3E%3Csearchradius%3E",
    radius,
    "%3C%2Fsearchradius%3E%3C%2Fformdata%3E%3C%2Frequest%3E"
  )
}

LA = get_url(limit=1000, zip_code=90210, radius=5000)     # get 1000 restaurants' information within radius of 5000 of LA
Hawaii = get_url(limit=1000, zip_code=96701, radius=5000)     # get 1000 restaurants' information within radius of 5000 of Hawaii
Utah = get_url(limit=1000, zip_code=84101, radius=5000)      # get 1000 restaurants' information within radius of 5000 of Utah
Washington = get_url(limit=1000, zip_code=20001, radius=5000)     # get 1000 restaurants' information within radius of 5000 of Washington

dir.create("data/dennys",recursive = TRUE, showWarnings = FALSE)   #create a directory

download.file(LA, dest="data/dennys/LA.xml", quiet = TRUE)   #resource of LA to be downloaded
download.file(Hawaii, dest="data/dennys/Hawaii.xml", quiet = TRUE)   #resource of Hawaii to be downloaded
download.file(Utah, dest="data/dennys/Utah.xml", quiet = TRUE)  #resource of Utah to be downloaded
download.file(Washington, dest="data/dennys/Washington.xml", quiet = TRUE)   #resource of Washington to be downloaded