# define function to get p value of interaction
# N should be 10,000 for the final analysis
get_p_int <- function(popn, group_var, N = 10){
  
  popn %<>% 
    filter(!is.na(group_var))
  #-------------------------------
  # permute the treatment allocation 
  # and rerun the test of homogeneity
  #-------------------------------
  
  # get actual treatment allocation
  treatment_alloc <- popn$tx 
  
  # contingency table and observed test statistic
  cont_empir <- table(popn$tx, popn$vital_180, popn %>% pull(group_var))
  
  ts_empir = epi.2by2(cont_empir)$massoc.detail$wRR.homog$test.statistic
  
  #-------------------------------
  # run the function N times to
  # set seed within parallel loops
  # for perfectly reproducible results
  #-------------------------------
  
  null_vec <- foreach(simi = 1:N, .combine = rbind) %dopar% {
    
    set.seed(simi)
    
    # pull random numbers the length of treatment vector from uniform distribution 0-1
    reshuffle_vec <- runif(length(treatment_alloc))
    
    # reshuffle the treatment allocation based on random numbers generated
    shuffled_arms <- treatment_alloc[order(reshuffle_vec)]
    
    # create contingency table using shuffled tx arms
    cont_permute <- table(shuffled_arms, popn$vital_180, popn %>% pull(group_var))
    
    # run the test of homogeneity on shuffled contingency tables
    # catch any errors that occur - assign as NA
    homog_test <- tryCatch(epi.2by2(cont_permute),
                           error = function(x) NA,
                           finally = function(x) epi.2by2(x))
    
    # if homog test worked, get test statistic
    if (class(homog_test) == "epi.2by2"){
      ts_permute = homog_test$massoc.detail$wRR.homog$test.statistic 
      # if homog test gave an error, assign NA to test statistic
    } else {
      ts_permute = NA
    }
    
    # extract and save the test statistic
    return(ts_permute)
  }
  
  #-------------------------------
  # calculate the permutation test p-value 
  #-------------------------------
  
  # subset null_vec to non_missing
  null_vec <- null_vec[!is.na(null_vec)]
  
  p_int <- sum(null_vec > ts_empir) / length(null_vec)
  
  return(p_int)
}