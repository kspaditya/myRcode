library(data.table)
library(bit64)

readBinary<-function(filename, objectVector, sizeVector, nameVector)
{
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

