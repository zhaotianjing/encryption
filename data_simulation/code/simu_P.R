library(rstiefel)
n=3534
P_n3534 = rustiefel(n, n)

setwd("/Users/tianjing/Library/CloudStorage/Box-Box/data_encryption/data_simulation")
write.table(P_n3534, "P_n3534.txt", col.names=F, row.names=F, sep=",")
