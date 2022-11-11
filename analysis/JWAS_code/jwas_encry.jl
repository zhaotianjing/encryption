pct               = parse(Float64, ARGS[1])
h2                = parse(Float64, ARGS[2])
rep               = parse(Int, ARGS[3]) 
chain_length      = 500_000

@show pct,h2,rep,chain_length
println("------------Encrypted data-------------")

#set working directroy
cd("/group/qtlchenggrp/tianjing/encryption/pct.$pct.h2.$h2/")

#load packages
using JWAS,DataFrames,CSV,Statistics,Random, DelimitedFiles

######################################################
# Step1. read data
######################################################
#read encrypted phenotypes and encrypted fixed effects
datapath             = "/group/qtlchenggrp/tianjing/encryption_data/pig_n3534_p50436/"
phenotypes_encrypted = CSV.read(datapath*"y_encrypted.h2.$h2.QTLpct.$pct.rep$rep.csv", DataFrame)
@show first(phenotypes_encrypted,10) #print first 10 rows

#read encrypted genotypes
@time genotypes = readdlm("/group/qtlchenggrp/tianjing/encryption_data/geno_qc_center_encrypted.txt", ',')
@show size(genotypes)

######################################################
# Step2. run JWAS (encrypted data)
######################################################
Random.seed!(1)
G = R = 1.0

genotypes2       = get_genotypes(genotypes,separator=',',G,G_is_marker_variance = true,center=false,method="BayesC",quality_control=false)
model_equation2  ="y = mu + cg_1 + cg_2 + cg_3 + cg_4 + genotypes2";
model2           = build_model(model_equation2,R);
set_covariate(model2,"mu")
set_covariate(model2,"cg_1")
set_covariate(model2,"cg_2")
set_covariate(model2,"cg_3")
set_covariate(model2,"cg_4")
out2             = runMCMC(model2,phenotypes_encrypted,chain_length=chain_length,double_precision=true, output_folder="rep.$rep.encrypted");

