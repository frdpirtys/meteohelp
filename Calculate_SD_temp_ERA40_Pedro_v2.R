#install.packages("ncdf4")
library(ncdf4)
library(raster)


# Path (use "/" and not "\")
file <- "D:/ERA_40_Test/44years_data.nc"
ncin <- nc_open(file)


## Exploratory data analysis
print(ncin)


## get longitude and latitude values and number of cells (=largo_datos)
lon <- ncvar_get(ncin,"longitude")
nlon <- dim(lon)
lat <- ncvar_get(ncin,"latitude")
nlat <- dim(lat)

largo_datos=nlon*nlat
print("largo de datos = n celdas")
largo_datos



# get time
time <- ncvar_get(ncin,"time")
print(time)  # just to have a look at the numbers  --> strange numbers, because they are arranged in hours. 
tunits <- ncatt_get(ncin,"time","units")
print(tunits) #Time since XX time
print(time)


#Change the time into a “normal” year-month-day - time format:
time_obs <- as.POSIXct(time*3600,origin='1900-01-01 00:00:00.0')  #3600 seconds is 1 hour. From tunits, we know the data is "hours since 1900-01-01 00:00:00.0"
time <- as.Date(as.character(time))
dim(time_obs)
range(time_obs)
time_obs


# get variable
attributes(ncin$var)
dname <- unlist(attributes(ncin$var))


# get dimensions
attributes(ncin$dim)



--------------------------------------------------------------------------------------------------
  
#The raster package has three basic types of data structures:
#  a “raster” for two dimensional data (e.g. lat-lon data)
#  a “brick”, which is for three dimensional data (e.g. lon-lon-time) where the data is in a single file
#  a “stack”, which is also three dimensional, but where the data is spread across multiple files (e.g. where you have one NetCDF file per month)


# load many raster slices from a brick

library(raster) 
temp_2m <- brick(file)
temp_2m
dim(temp_2m)
names(temp_2m)


## extracting multiple raster
extract <- c(names(temp_2m))


## create an inventory of the slices
#name <- names(temp_2m)
#dates <- gsub("X", "", name) #sub and gsub perform replacement of the first and all matches respectively.
#dates <- as.Date(dates, format = "%Y.%m.%d.H%.M%.S%")

name <- names(temp_2m)
dates <- gsub("X", "", name, "", time) #sub and gsub perform replacement of the first and all matches respectively.
dates <- as.Date(dates, format = "%Y.%m.%d")


# store it in data.frame
library(lubridate)

df <- data.frame("name" = name, "date" = dates)
df$day <- day(df$date)
df$month <- month(df$date)
df$year <- year(df$date)

#El solito
#df_sub <- df[df$day == 03, ]
#slices <- df_sub$name
#temp_subset <- temp_2m[[slices]]
#avg_temp <- mean(temp_subset)-273
#plot(avg_temp)


# identify names of slices to subset

#adjust years of interest
yr_from = 1958
yr_until= 2000 #1959

x = yr_until-yr_from
n_rows = (x+1)*12

#matrix for all the data, 12 months for x number of years
AllData_sdT = matrix(nrow = n_rows, ncol = largo_datos) 
AllData_Tm = matrix(nrow = n_rows, ncol = largo_datos) 

contador=1


# CORRER PRÓXIMA LÍNEA Y DE AHÍ NO CORRER NADA MÁS HASTA  LINEA 672 APROX.. FINAL DEL FOR
for (k in yr_from:yr_until) { 
  
  #matrix for January (rows= days, columns= n cells)
  January=matrix(nrow = 31, ncol = largo_datos) 
  MeanJanuary=matrix(nrow = 1, ncol = largo_datos)
  SDevJanuary=matrix(nrow = 1, ncol = largo_datos)

  #matrix for February (rows= days, columns= n cells)
  February=matrix(nrow = 28, ncol = largo_datos) 
  MeanFebruary=matrix(nrow = 1, ncol = largo_datos)
  SDevFebruary=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for March (rows= days, columns= n cells)
  March=matrix(nrow = 31, ncol = largo_datos) 
  MeanMarch=matrix(nrow = 1, ncol = largo_datos)
  SDevMarch=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for April (rows= days, columns= n cells)
  April=matrix(nrow = 30, ncol = largo_datos) 
  MeanApril=matrix(nrow = 1, ncol = largo_datos)
  SDevApril=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for May (rows= days, columns= n cells)
  May=matrix(nrow = 31, ncol = largo_datos) 
  MeanMay=matrix(nrow = 1, ncol = largo_datos)
  SDevMay=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for Juni (rows= days, columns= n cells)
  June=matrix(nrow = 30, ncol = largo_datos) 
  MeanJune=matrix(nrow = 1, ncol = largo_datos)
  SDevJune=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for July (rows= days, columns= n cells)
  July=matrix(nrow = 31, ncol = largo_datos) 
  MeanJuly=matrix(nrow = 1, ncol = largo_datos)
  SDevJuly=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for August (rows= days, columns= n cells)
  August=matrix(nrow = 31, ncol = largo_datos) 
  MeanAugust=matrix(nrow = 1, ncol = largo_datos)
  SDevAugust=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for September (rows= days, columns= n cells)
  Sept=matrix(nrow = 30, ncol = largo_datos) 
  MeanSept=matrix(nrow = 1, ncol = largo_datos)
  SDevSept=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for October (rows= days, columns= n cells)
  October=matrix(nrow = 31, ncol = largo_datos) 
  MeanOctober=matrix(nrow = 1, ncol = largo_datos)
  SDevOctober=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for November (rows= days, columns= n cells)
  November=matrix(nrow = 30, ncol = largo_datos) 
  MeanNovember=matrix(nrow = 1, ncol = largo_datos)
  SDevNovember=matrix(nrow = 1, ncol = largo_datos)
  
  #matrix for December (rows= days, columns= n cells)
  December=matrix(nrow = 31, ncol = largo_datos) 
  MeanDecember=matrix(nrow = 1, ncol = largo_datos)
  SDevDecember=matrix(nrow = 1, ncol = largo_datos)
  
  
  
  # FOR JANUARY
  for (i in 1:31){
  df_sub <- df[(df$day==i) & (df$month==1) & (df$year==k),]
  
  slices <- df_sub$name
  temp_subset <- temp_2m[[slices]]
  avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
  
  January[i,1:largo_datos]<-values(avg_day)
  #plot(avg_day)
  
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevJanuary[1,j]=sd(January[1:31,j])
    MeanJanuary[1,j]=mean(January[1:31,j])
  }
  
  values(T_sd)<-SDevJanuary
  values(T_mean)<-MeanJanuary
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name1 <- paste("C:/output_ERA/sdT_",k,"_01_January.tif", sep = "")
  writeRaster(T_sd, out_name1, overwrite = T)
  out_name2 <- paste("C:/output_ERA/Tmean_",k,"_01_January.tif", sep = "" )
  writeRaster(T_mean, out_name2, overwrite = T)
  

  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevJanuary #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanJanuary
  contador=contador+1 #para pasar a febrero que es el próximo mes
    

  
  # FOR FEBRUARY
  for (i in 1:28){
  df_sub <- df[(df$day==i) & (df$month==2) & (df$year==k),]
  
  slices <- df_sub$name
  temp_subset <- temp_2m[[slices]]
  avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
  
  February[i,1:largo_datos]<-values(avg_day)
  #plot(avg_day)
  
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevFebruary[1,j]=sd(February[1:28,j])
    MeanFebruary[1,j]=mean(February[1:28,j])
  }
  
  values(T_sd)<-SDevFebruary
  values(T_mean)<-MeanFebruary
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name3 <- paste("C:/output_ERA/sdT_",k,"_02_February.tif", sep = "")
  writeRaster(T_sd, out_name3, overwrite = T)
  out_name4 <- paste("C:/output_ERA/Tmean_",k,"_02_February.tif", sep = "" )
  writeRaster(T_mean, out_name4, overwrite = T)
  

  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevFebruary #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanFebruary
  contador=contador+1 #para pasar a marzo que es el próximo mes
  
  
  
  # FOR MARCH
  for (i in 1:31){
    df_sub <- df[(df$day==i) & (df$month==3) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    March[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevMarch[1,j]=sd(March[1:31,j])
    MeanMarch[1,j]=mean(March[1:31,j])
  }
  
  values(T_sd)<-SDevMarch
  values(T_mean)<-MeanMarch
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name5 <- paste("C:/output_ERA/sdT_",k,"_03_March.tif", sep = "")
  writeRaster(T_sd, out_name5, overwrite = T)
  out_name6 <- paste("C:/output_ERA/Tmean_",k,"_03_March.tif", sep = "" )
  writeRaster(T_mean, out_name6, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevMarch #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanMarch
  contador=contador+1 #para pasar a abril que es el próximo mes
  
  
  
  # FOR April
  for (i in 1:30){
    df_sub <- df[(df$day==i) & (df$month==4) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    April[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevApril[1,j]=sd(April[1:30,j])
    MeanApril[1,j]=mean(April[1:30,j])
  }
  
  values(T_sd)<-SDevApril
  values(T_mean)<-MeanApril
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name7 <- paste("C:/output_ERA/sdT_",k,"_04_April.tif", sep = "")
  writeRaster(T_sd, out_name7, overwrite = T)
  out_name8 <- paste("C:/output_ERA/Tmean_",k,"_04_April.tif", sep = "" )
  writeRaster(T_mean, out_name8, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevApril #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanApril
  contador=contador+1 #para pasar a mayo que es el próximo mes
  
  
  
  # FOR May
  for (i in 1:31){
    df_sub <- df[(df$day==i) & (df$month==5) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    May[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevMay[1,j]=sd(May[1:31,j])
    MeanMay[1,j]=mean(May[1:31,j])
  }
  
  values(T_sd)<-SDevMay
  values(T_mean)<-MeanMay
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name9 <- paste("C:/output_ERA/sdT_",k,"_05_May.tif", sep = "")
  writeRaster(T_sd, out_name9, overwrite = T)
  out_name10 <- paste("C:/output_ERA/Tmean_",k,"_05_May.tif", sep = "" )
  writeRaster(T_mean, out_name10, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevMay #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanMay
  contador=contador+1 #para pasar a junio que es el próximo mes
  
  
  
  # FOR June
  for (i in 1:30){
    df_sub <- df[(df$day==i) & (df$month==6) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    June[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevJune[1,j]=sd(June[1:30,j])
    MeanJune[1,j]=mean(June[1:30,j])
  }
  
  values(T_sd)<-SDevJune
  values(T_mean)<-MeanJune
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name11 <- paste("C:/output_ERA/sdT_",k,"_06_June.tif", sep = "")
  writeRaster(T_sd, out_name11, overwrite = T)
  out_name12 <- paste("C:/output_ERA/Tmean_",k,"_06_June.tif", sep = "" )
  writeRaster(T_mean, out_name12, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevJune #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanJune
  contador=contador+1 #para pasar a juLio que es el próximo mes
  
  
  
  # FOR JULY
  for (i in 1:31){
    df_sub <- df[(df$day==i) & (df$month==7) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    July[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevJuly[1,j]=sd(July[1:31,j])
    MeanJuly[1,j]=mean(July[1:31,j])
  }
  
  values(T_sd)<-SDevJuly
  values(T_mean)<-MeanJuly
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name13 <- paste("C:/output_ERA/sdT_",k,"_07_July.tif", sep = "")
  writeRaster(T_sd, out_name13, overwrite = T)
  out_name14 <- paste("C:/output_ERA/Tmean_",k,"_07_July.tif", sep = "" )
  writeRaster(T_mean, out_name14, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevJuly #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanJuly
  contador=contador+1 #para pasar a agosto que es el próximo mes
  
  
  
  # FOR AUGUST
  for (i in 1:31){
    df_sub <- df[(df$day==i) & (df$month==8) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    August[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevAugust[1,j]=sd(August[1:31,j])
    MeanAugust[1,j]=mean(August[1:31,j])
  }
  
  values(T_sd)<-SDevAugust
  values(T_mean)<-MeanAugust
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name15 <- paste("C:/output_ERA/sdT_",k,"_08_August.tif", sep = "")
  writeRaster(T_sd, out_name15, overwrite = T)
  out_name16 <- paste("C:/output_ERA/Tmean_",k,"_08_August.tif", sep = "" )
  writeRaster(T_mean, out_name16, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevAugust #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanAugust
  contador=contador+1 #para pasar a sept que es el próximo mes
  
  
  
  # FOR SEPT
  for (i in 1:30){
    df_sub <- df[(df$day==i) & (df$month==9) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    Sept[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevSept[1,j]=sd(Sept[1:30,j])
    MeanSept[1,j]=mean(Sept[1:30,j])
  }
  
  values(T_sd)<-SDevSept
  values(T_mean)<-MeanSept
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name17 <- paste("C:/output_ERA/sdT_",k,"_09_Sept.tif", sep = "")
  writeRaster(T_sd, out_name17, overwrite = T)
  out_name18 <- paste("C:/output_ERA/Tmean_",k,"_09_Sept.tif", sep = "" )
  writeRaster(T_mean, out_name18, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevSept #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanSept
  contador=contador+1 #para pasar a oct que es el próximo mes
  
  
  
  # FOR October
  for (i in 1:31){
    df_sub <- df[(df$day==i) & (df$month==10) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    October[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevOctober[1,j]=sd(October[1:31,j])
    MeanOctober[1,j]=mean(October[1:31,j])
  }
  
  values(T_sd)<-SDevOctober
  values(T_mean)<-MeanOctober
 #plot(T_sd)
 #plot(T_mean)
  
  # save raster files
  out_name19 <- paste("C:/output_ERA/sdT_",k,"_10_October.tif", sep = "")
  writeRaster(T_sd, out_name19, overwrite = T)
  out_name20 <- paste("C:/output_ERA/Tmean_",k,"_10_October.tif", sep = "" )
  writeRaster(T_mean, out_name20, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevOctober #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanOctober
  contador=contador+1 #para pasar a NOV que es el próximo mes
  
  
  
  # FOR November
  for (i in 1:30){
    df_sub <- df[(df$day==i) & (df$month==11) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    November[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevNovember[1,j]=sd(November[1:30,j])
    MeanNovember[1,j]=mean(November[1:30,j])
  }
  
  values(T_sd)<-SDevNovember
  values(T_mean)<-MeanNovember
 #plot(T_sd)
 #plot(T_mean)
  
  #save raster files
  out_name21 <- paste("C:/output_ERA/sdT_",k,"_11_November.tif", sep = "")
  writeRaster(T_sd, out_name21, overwrite = T)
  out_name22 <- paste("C:/output_ERA/Tmean_",k,"_11_November.tif", sep = "" )
  writeRaster(T_mean, out_name22, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevNovember #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanNovember
  contador=contador+1 #para pasar a DIC que es el próximo mes
  
  
  
  # FOR December
  for (i in 1:31){
    df_sub <- df[(df$day==i) & (df$month==10) & (df$year==k),]
    
    slices <- df_sub$name
    temp_subset <- temp_2m[[slices]]
    avg_day <- mean(temp_subset)-273 # to convert from Kelvin to Celcius
    
    December[i,1:largo_datos]<-values(avg_day)
    #plot(avg_day)
    
  }
  
  T_sd=avg_day*0
  T_mean=avg_day*0
  
  j=1  
  for (j in 1:largo_datos){ # get mean monthly temp and std deviation of daily means per cell!
    SDevDecember[1,j]=sd(December[1:31,j])
    MeanDecember[1,j]=mean(December[1:31,j])
  }
  
  values(T_sd)<-SDevDecember
  values(T_mean)<-MeanDecember
 #plot(T_sd)
 #plot(T_mean)
  
  # save raster files
  out_name15 <- paste("C:/output_ERA/sdT_",k,"_12_December.tif", sep = "")
  writeRaster(T_sd, out_name15, overwrite = T)
  out_name16 <- paste("C:/output_ERA/Tmean_",k,"_12_December.tif", sep = "" )
  writeRaster(T_mean, out_name16, overwrite = T)
  
  
  # add this month data to matrix with all the data!
  AllData_sdT[contador,1:largo_datos] <-SDevDecember #para fila en contador y columna de 1 al final de largo datos
  AllData_Tm[contador,1:largo_datos] <- MeanDecember
  contador=contador+1 #para pasar a ENERO de próximo año
  
} #FINAL DEL FOR LOOP!




#################### exportar matrices con datos de sdT y Tm
###################  para todos los meses para todos los pixeles.


write.table(AllData_sdT, 'D:/ERA_40_Test/AllData_sdT_matrix.csv', append = FALSE, sep = ";", dec = ".",
            row.names = FALSE, col.names = FALSE)


write.table(AllData_Tm, 'D:/ERA_40_Test/AllData_Tm_matrix.csv', append = FALSE, sep = ";", dec = ".",
            row.names = FALSE, col.names = FALSE)




###################################### ahora la hora de la verdad.... ###################### least squares, inicialmente sin weighting


# 1. reorganizar los datos en matrices que nos sirvan....


All_Tm  = as.vector(AllData_Tm)
All_sdT = as.vector(AllData_sdT)

if ( length(AllData_sdT) != length(All_Tm) ){
  warning("Matrix dimensions do not fit!!")
}

n=length(All_Tm)

# Matriz G, va a tener dos columnas: primera columna son valores de Tm, segunda columna puros 1
# G = [Tm1 1; Tm2 1; etc..]

G=matrix(data=NA, nrow=n, ncol = 2)

G[1:n,1]<-All_Tm # valores de Tm en columna izquierda (1)
G[1:n,2]<-1      # valor 1 para toda la columna derecha (2)

G

# Matriz d, va a tener una columna con los valores de standar deviation T

d=matrix(data=NA, nrow=n, ncol = 1)

d[1:n,1]<-All_sdT

d


# 2. realizar las operaciones con matrices
#
# least squares solution: m=[G.t*G]-1 * G.t * d

library(matlib)

# Multiplicacion de matrices:  A %*%  B
# transpuesta de una matriz:   t(A)
# inversa de una matriz: inv(A)

# I will call matrix A = G.t*G
A= t(G) %*% G

A


m= inv(A) %*% t(G) %*% d


print("a=")
m[1]
print("b=")
m[2]

write.table(m, 'D:/ERA_40_Test/model_matrix__least_squares_result_Rstudio.csv', append = FALSE, sep = ";", dec = ".",
            row.names = FALSE, col.names = FALSE)

### enhorabuena, tenemos los valores para pism!


#### esto es para exportar los valores para graficar quizas en otro programa


# library(MASS) #esta no sé si es necesaria o no para exportar
write.csv(All_sdT, file="D:/ERA_40_Test/All_sdT_vector.csv", row.names = F, col.names = "y")
write.csv(All_Tm, file="D:/ERA_40_Test/All_Tm_vector.csv", row.names = F, col.names = "x")
