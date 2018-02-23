polygonizer = function(x, quiet=TRUE)
{
  library(sf)
  library(raster)
  
  cmd = 'python'
  pypath = Sys.which('gdal_polygonize.py')
  if (!file.exists(pypath)) 
    stop("Could not find gdal_polygonize.py.") 
  
  outshape = tempfile()
  f = tempfile(fileext='.tif')
  writeRaster(x, f)
  rastpath = normalizePath(f)
  
  system2(
    cmd, 
    args=(
      sprintf(
        '"%s" "%s" %s -f "ESRI Shapefile" "%s.shp"', 
        pypath, rastpath, ifelse(quiet, '-q ', ''), 
        outshape
      )
    )
  )
  
  shp = st_transform(st_read(dirname(outshape), quiet=quiet), 4326)
  names(shp) = c("Precinct","geometry")
  
  #unlink(f)
  #unlink(outshape,recursive = TRUE)
  
  shp
}