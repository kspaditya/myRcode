library(data.table)
library(bit64)

writeBinary <- function(dt, filename, sizeVector){

  names_dt = names(dt)
  sizePerRecord = sum(sizeVector)
  nrecords=nrow(dt)


  if(length(names_dt) != length(sizeVector)){
    return(NULL)
  }

  dt_pos = data.table(size=sizeVector,
                      start = cumsum(c(1,sizeVector))[1:length(sizeVector)],
                      end = cumsum(sizeVector))

  dt_raw = rbindlist(lapply(1:length(sizeVector), function(i){
    pos = (dt_pos[i]$start:dt_pos[i]$end)
    return(data.table(recNum=rep(1:nrecords,each=length(pos)),
                      posNum = rep(pos, times=nrecords),
                      rawData = writeBin(dt[, get(names_dt[i])], raw(), size = sizeVector[i])))
  }))

  dt_raw = dt_raw[order(recNum)]

  fileCon = file(filename, 'wb')
  writeBin(dt_raw$rawData, fileCon)
  close(fileCon)

}

writeBinary(dt, "D:\\myRcode\\Data\\output.dat",  c(rep(4,12)))

