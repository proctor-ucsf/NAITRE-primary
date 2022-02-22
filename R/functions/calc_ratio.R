# define function for calculating hazard ratios
calc_ratio <- function(df, var, outcome, dist_link) {
  # for each tx group, get:
  
  # for outcomes with binomial distriubtion
  if (dist_link == "binomial_clglg") {
    
    # total number of participants with a response
    N_Az = df %>% filter(outcome %in% c(0,1) & tx == "Azithromycin") %>% nrow()
    N_Pl = df %>% filter(outcome %in% c(0,1) & tx == "Placebo") %>% nrow() 
    
    # number of participants with outcome of interest
    n_Az = df %>% filter(outcome == 1 & tx == "Azithromycin") %>% nrow()
    n_Pl = df %>% filter(outcome == 1 & tx == "Placebo") %>% nrow()
    
    # proportion with outcome of interest
    p_Az = percent(n_Az/N_Az, accuracy = .01)
    p_Pl = percent(n_Pl/N_Pl, accuracy = .01)
    
    # run model
    mod_empir <- glm(outcome ~ tx, data = df, family = binomial(link = cloglog))
  }
  
  # for outcomes with poisson distribution
  else if (dist_link == "poisson_lglnk") { 
    
    # total number of participants with a response
    N_Az = df %>% filter(outcome > 0 & tx == "Azithromycin") %>% nrow()
    N_Pl = df %>% filter(outcome > 0 & tx == "Placebo") %>% nrow() 
    
    # count of outcomes of interest
    n_Az = df %>% mutate(outcome = as.numeric(outcome)) %>% filter(tx == "Azithromycin") %>% select(outcome) %>% colSums() 
    n_Pl = df %>% mutate(outcome = as.numeric(outcome)) %>% filter(tx == "Placebo") %>% select(outcome) %>% colSums() 
    
    # mean number of outcomes per participant
    p_Az = round(n_Az/N_Az, 2)
    p_Pl = round(n_Pl/N_Pl, 2)
    
    # run model
    mod_empir <- glm(outcome ~ tx, data = df, family = poisson(link = log))
  }
  
  # save a model summary
  mod_summary <- summary(mod_empir)
  
  # save the log HR and its SE
  coef_empir <- mod_summary$coef[2,1]
  se_empir <- mod_summary$coef[2,2]
  
  # calculate the upper and lower limits on the HR ratio (coefficient from the model)
  upper_empir <- exp(coef_empir+(1.96*se_empir)) %>% round(3)
  lower_empir <- exp(coef_empir-(1.96*se_empir)) %>% round(3)
  coef_empir_exp <- exp(coef_empir) %>% round(3)
  
  # tabulate outcomes
  prediction <- data.frame(var = var,
                           N_Az = N_Az,
                           n_Az = n_Az,
                           p_Az = p_Az,
                           N_Pl = N_Pl,
                           n_Pl = n_Pl,
                           p_Pl = p_Pl,
                           coef = coef_empir,
                           ratio = coef_empir_exp,
                           upper = upper_empir,
                           lower = lower_empir,
                           p_value = NA_real_
  )
  return(prediction)
}
