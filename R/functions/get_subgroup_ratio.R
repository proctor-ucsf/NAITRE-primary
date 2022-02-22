# define function to calculate hr by subgroup
get_subgroup_ratio <- function(popn, group_var, N=10){
  # group data by subgroup variable, and select for non-missing values
  popn %<>% 
    rename(grp = all_of(group_var)) %>%
    filter(!is.na(grp)) %>% 
    group_by(grp)
  
  do(popn, 
     # The number of permutations here doesn't have to be 10K since we mostly care about the permutation test on the test of homogeneity
     calc_ratio_pval(df = ., as.character(group_var), death_response_180, "binomial_clglg", N = 10)) %>% 
    # get p of interaction for the subgroup
    mutate(p_int = get_p_int(popn = d_interaction, group_var = group_var, N = N))
}