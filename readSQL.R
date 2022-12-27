library(RODBC)
library(data.table)


dbhandle <- odbcDriverConnect(paste("driver={SQL Server};
                              server=",serverName,";
                              database=",DBName,";
                              trusted_connection=true", sep=""))

res <- sqlQuery(dbhandle, paste("select * From dbo.", tbl, sep=""))

odbcClose(dbhandle)

res = as.data.table(res)
