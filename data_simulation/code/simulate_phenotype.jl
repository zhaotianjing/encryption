cd("/group/qtlchenggrp/tianjing/encryption_data/pig_n3534_p50436")
using DelimitedFiles,Statistics,Random,CSV,DataFrames,StatsBase
Random.seed!(1)

# #QC for genotype
# maf=vec(mean(geno_matrix,dims=1)/2)
# select1=0.01.<maf.<0.99
# fixed=vec(var(geno_matrix,dims=1))
# select2 = fixed.!=0
# selectAll = select1 .& select2
# geno_qc=geno_matrix[:,selectAll]
# writedlm("geno_qc.txt",geno_qc)

#in total 16 combinations of h2 and pi
h2_ALL     = [0.1, 0.3, 0.5, 0.7] #4 possible h2
QTLpct_ALL = [0.01, 0.1, 0.5, 1]  #4 possible QTL%
repALL     = 10

#read QC genotype (nInd=3534, nSNP=50436)
@time geno=readdlm("/group/qtlchenggrp/tianjing/encryption_data/geno_qc.txt")
n,p=size(geno)
@show n,p
### read orthogonal matrix (size: nInd-by-nInd)
P = readdlm("/group/qtlchenggrp/tianjing/encryption_data/P_n3534.txt",',')
@show size(P)

for h2 in h2_ALL
    for pct in QTLpct_ALL
        σ2_g = h2
        σ2_e = 1-h2
        nQTL = Int(floor(p*pct)) #number of QTLs
        println("h2 is $h2 ; QTLpct is $pct; σ2_g is $σ2_g; σ2_e is $σ2_e; nQTL is $nQTL")
        
        for rep in 1:repALL
            println("-- rep: ",rep)
            ########################################################################
            # Step1. generate raw data
            ########################################################################
            ##breeding values
            QTL_pos    = sample(1:p,nQTL,replace=false, ordered=true) #random sample of QTL positions
            QTL_effect = randn(nQTL) #random sample of QTL effects
            bv         = geno[:,QTL_pos]*QTL_effect
            bv         = bv/std(bv)*sqrt(σ2_g)
            ##fixed effects
            simulated_group = sample(1:4,n)                    #simulate groups
            p_fixed         = length(unique(simulated_group))  #start to make incidence matrix X
            X               = zeros(n,p_fixed)                 #initialize incidence matrix X
            for i = 1:n
                j      = simulated_group[i]
                X[i,j] = 1.0
            end
            fixed_effects = randn(p_fixed)
            ##phenotypes
            phenotype     = X*fixed_effects + bv + randn(n)*sqrt(0.5)

            ## make dataframes for JWAS
            simulated_group = "group_".*string.(simulated_group)
            pheno_df        = [simulated_group phenotype bv]
            pheno_df        = DataFrame(pheno_df,["cg","y","bv"])
            insertcols!(pheno_df, 1, :ID => 1:n);
            
            println("The var(bv) is ",round(var(bv),digits=3), "; The var(y) is ",round(var(phenotype),digits=3), "; The mean(y) is ", round(mean(phenotype), digits=3))

            ##save phenotype and true breeding values
            CSV.write("y.h2.$h2.QTLpct.$pct.rep$rep.csv",  pheno_df)

            ########################################################################
            # Step2. generate encrypted data
            ########################################################################
            ## encrypted phenotypes
            phenotype_encrypted = P * phenotype
            ## encrypted fixed effects
            X_all               = [ones(n) X] #including intercept
            X_encrypted         = P * X_all
            ## make dataframes for JWAS
            pheno_encrypted_df  = [X_encrypted phenotype_encrypted]
            pheno_encrypted_df  = DataFrame(pheno_encrypted_df,["mu","cg_1","cg_2","cg_3","cg_4","y"])
            insertcols!(pheno_encrypted_df, 1, :ID => 1:n);
            ## save encrypted phenotypes and encrypted fixed effects
            CSV.write("y_encrypted.h2.$h2.QTLpct.$pct.rep$rep.csv",  pheno_encrypted_df)
        end
    end
end 

