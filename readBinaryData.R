library(data.table)
library(bit64)

readBinary<-function(filename, objectVector, sizeVector, nameVector)
{
  if(length(objectVector) != length(sizeVector)){
    return(NULL)
  }

  if(length(nameVector) != length(sizeVector)){
    return(NULL)
  }

  fileCon=file(filename,"rb")
  fileSize<-file.info(filename)$size
  raw<-readBin(fileCon,"raw",n=fileSize,endian="little")
  close(fileCon)

  sizePerRecord = sum(sizeVector)
  nrecords=(fileSize)/sizePerRecord
  rawBytes <- matrix(raw,nrow=sizePerRecord)

  dt = data.table()
  end = 0
  for(i in 1:length(objectVector)){
    start = end + 1
    end = start + sizeVector[i] - 1
    dt[,eval(nameVector[i]):=readBin(as.vector(rawBytes[start:end,]),objectVector[i],
                                     size=sizeVector[i],n=nrecords,endian="little")]
  }
  return(dt)
}

dt=readBinary(brag_detfiles[1],
           c(rep("integer", 5), rep("numeric", 7)),
           c(rep(4,12)),
           c("year", "histkey", "month", "day", "doy", "pre",
              "etc0", "tmax", "tmin", "rs", "rh", "u2"))

