#-------------------------------
# generate the null permutation distribution
# permute the treatment allocation and rerun the model to 
# estimate distribution of the model coefficient under the Null
#-------------------------------

# define function to estimate coefficient under the null hypothesis
# calls `calc_ratio`
# N should be 10,000 for the final analysis
calc_ratio_pval <- function(df, var, outcome, dist_link, N = 10) {
  # get actual treatment allocation
  treatment_alloc <- df$tx 
  
  # attach dataset to be used
  attach(df)
  
  # get the empirical values
  empir = calc_ratio(df, var, outcome, dist_link)
  
  # detach dataset used
  detach(df)
  
  coef_empir = empir$coef
  
  #-------------------------------
  # run the function N times to 
  # produce the null distribution of the log HR
  # set seed within parallel loops
  # for perfectly reproducible results
  #-------------------------------
  
  null_vec <- foreach(simi = 1:N, .combine = rbind) %dopar% {
    
    set.seed(simi)
    
    # pull random numbers the length of treatment vector from uniform distribution 0-1
    reshuffle_vec <- runif(length(treatment_alloc))
    
    # reshuffle the treatment allocation based on random numbers generated
    shuffled_arms <- treatment_alloc[order(reshuffle_vec)]
    
    # run the model on shuffled allocation
    if (dist_link == "binomial_clglg") { 
      mod <- glm(outcome ~ shuffled_arms, family = binomial(link = cloglog))
    }
    
    else if (dist_link == "poisson_lglnk") { 
      mod <- glm(outcome ~ shuffled_arms, family = poisson(link = log))
    }
    
    # extract and save the coefficient
    return(mod$coefficients[2])
  }
  
  #-------------------------------
  # calculate the 2-sided 
  # permutation test p-value 
  #-------------------------------
  p_val <- sum(abs(null_vec) > abs(coef_empir)) / length(null_vec)
  
  # add p value to emprical values
  empir %<>% mutate(p_value = p_val)
  
  return(empir)
}