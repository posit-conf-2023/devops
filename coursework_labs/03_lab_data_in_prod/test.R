# Load Libraries ----------------------------------------------------------
library(plumber)
library(tidymodels)
library(tidyverse)

# Fit model
cars_model <- lm(mpg ~ cyl + hp, data = mtcars)
saveRDS(cars_model, "cars-model.rds")


# API ---------------------------------------------------------------------


#* How many mpg should we expect?
#* @post /predict_mpg
function(req, res) {
  predict(cars_model, new_data = as.data.frame(req$body))
}
#> function(req, res) {
#>   predict(trained_mod, new_data = as.data.frame(req$body))
#> }

# Update UI
#* @plumber
function(pr) {
  pr %>% pr_set_api_spec(yaml::read_yaml("openapi.yaml"))
}
#> function(pr) {
#>   pr %>% pr_set_api_spec(yaml::read_yaml("cars_yml.yml"))
#> }
  
  
  
  
  
  
  
  

