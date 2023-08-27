docker build -t my-app . --platform linux/amd64

docker run --rm -p 3838:3838 --platform linux/amd64 \
-v ./apps:/srv/shinyapps \
-v ./logs:/var/log/shiny-server \doc
-v ./conf:/etc/shiny-server \
my-app 

# visit http://localhost:3838 to see the app

# in detached mode
docker run -d -p 3838:3838 --platform linux/amd64 \
-v ./logs:/var/log/shiny-server \
-v ./conf:/etc/shiny-server \
my-app 


# identify container information and processes runnng
docker ps
# exec into container
docker exec -it {container} /bin/bash
# list imagess
docker image ls

# runs on http://localhost:3838
# remove platform option if running on intel instead of M1
# check architecture by running arch
# -p 3838:3838 maps your local port 3838, to the same port inside the container where shiny server is listening.