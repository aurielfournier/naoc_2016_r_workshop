file_names <- list.files(pattern=".csv")

# these are the vectors of values that I am ok with, with the correct spellings

# areas are my study areas
areas <- c("nvca","scnwr","fgca","slnwr","tsca","bkca","ccnwr","dcca","osca","tmpca")

# impound is my wetland impoundments
impound <- c("rail","sanctuary","ash","scmsu2","scmsu3","sgd","sgb","pool2","pool2w","pool3w","m11","m10","m13","ts2a","ts4a","ts6a","ts8a","kt9","kt2","kt5","kt6","ccmsu1","ccmsu2","ccmsu12","dc14","dc18","dc20","dc22","os21","os23","pooli","poole","poolc")

# regions are the four regions
regions <- c("nw","nc","ne","se")

# plant spellings that are correct 
plant <- c("reed canary grass","primrose","millet","bulrush","partridge pea","spikerush","a smartweed","p smartweed","willow","tree","buttonbush","arrowhead","river bulrush","biden","upland","cocklebur","lotus","grass","cattail","prairie cord grass","plantain","sedge","sesbania","typha","corn","sumpweed","toothcup","frogfruit","canola","sedge","crop","rush","goldenrod",NA)

for(i in 1:length(file_names)){
  int <-  read.csv(file_names[i])
# so this prints out instances where three are things that are not part of the lists above and includes the file name so I can go and find the issue.   
  print(paste0(int[(int$region %in% regions==FALSE),]$region," ",file_names[i]," region"))
  print(paste0(int[(int$area %in% areas==FALSE),]$area," ",file_names[i]," area"))
  print(paste0(int[(int$impound %in% impound==FALSE),]$impound," ",file_names[i]," impound"))
  print(paste0(int[(int$plant1 %in% plant==FALSE),]$plant1," ",file_names[i]," plant1"))
  print(paste0(int[(int$plant2 %in% plant==FALSE),]$plant2," ",file_names[i]," plant2"))
  print(paste0(int[(int$plant3 %in% plant==FALSE),]$plant3," ",file_names[i]," plant3"))
}

## once I resolve all of the issues identified from above I then read in all the files, put them in a list and I can stitch them together into one master file. 

vegsheets <- list()

for(i in 1:length(file_names)){
  vegsheets[[i]] <- read.csv(file_names[i])
}

## this takes the list and combines it all together into one data frame
masterdat <- do.call(rbind, vegsheets)

# write it out into a master file
write.csv(masterdat, "~/Github/data/2015_veg_master.csv", row.names=FALSE)