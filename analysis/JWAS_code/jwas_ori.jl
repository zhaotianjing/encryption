pct               = parse(Float64, ARGS[1])
h2                = parse(Float64, ARGS[2])
rep               = parse(Int, ARGS[3]) 
chain_length      = 500_000

@show pct,h2,rep,chain_length
println("------------Raw data-------------")

#set working directroy
cd("/group/qtlchenggrp/tianjing/encryption/pct.$pct.h2.$h2/")

#load packages
using JWAS,DataFrames,CSV,Statistics,Random, DelimitedFiles

######################################################
# Step1. read data
######################################################
#read phenotypes
datapath = "/group/qtlchenggrp/tianjing/encryption_data/pig_n3534_p50436/"
phenotypes = CSV.read(datapath*"y.h2.$h2.QTLpct.$pct.rep$rep.csv",DataFrame)
@show first(phenotypes,10) #print first 10 rows

#read genotypes
@time genotypes = readdlm("/group/qtlchenggrp/tianjing/encryption_data/geno_qc_center.txt", ',')
@show size(genotypes)

######################################################
# Step2. run JWAS (raw data)
######################################################
Random.seed!(1)
G = R = 1.0
genotypes1       = get_genotypes(genotypes,separator=',',G,G_is_marker_variance = true,center=false,method="BayesC",quality_control=false)
model_equation1  = "y = intercept + cg + genotypes1";
model1           = build_model(model_equation1,R);
out1             = runMCMC(model1, phenotypes, chain_length=chain_length, double_precision=true, output_folder="rep.$rep.raw");


