## ---- api-setup
library(plumber)

# Load model
# Depending on model size, this can be a fairly expensive operation
cars_model <- readRDS("cars-model.rds")

#* @apiTitle mtcars model API
#* @apiDescription Endpoints for working with mtcars dataset model

## ---- filter-logger

#* Log some information about the incoming request
#* @filter logger
function(req){
  cat(as.character(Sys.time()), "-",
      req$REQUEST_METHOD, req$PATH_INFO, "-",
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  forward()
}


## ---- health check

#* @get /healthcheck
healthcheck <- function() {
  list(
    "timestamp" = Sys.time(),
    "api-status" = "listening")
}

validate_data <- function(data) {
  length(intersect(names(data), c("cyl", "hp"))) == 2
}

## ---- post-data

#* Predict on input values
#* @post /predict
function(req, res) {
  predict(model, req$body)
}


#* @plumber
function(pr){
  pr |>
    pr_set_api_spec("yaml::read_yaml(openapi.yaml")
}

  
  
  
  
  
  
  
  
  

