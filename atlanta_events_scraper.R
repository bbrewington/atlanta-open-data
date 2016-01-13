## R code to grab info off of Atlanta's events calendar at http://www.atlantaga.gov/index.aspx?page=658

library(rvest)

# Step 1: Extract elements from calendar view
page <- "http://www.atlantaga.gov/index.aspx?page=658"
page.html <- read_html(page)
page.html %>% html_nodes("td") %>% html_text()

# Step 1 result: data frame of page links and corresponding event titles
df <- data.frame(links = page.html %>% html_nodes("tr > td > a") %>% 
                      html_attr("href"),
                 events = page.html %>% html_nodes("tr > td > a") %>%
                      html_text)

# Step 2: Go to each link in data frame df, and grab key info
# function to grab key elements from an Atlanta Event page link, as data frame
get_event_details <- function(event.page){
     event.page.html <- read_html(event.page)
     event.title <- event.page.html %>% html_node("#ctl00_titleLabel") %>% html_text()
     event.time <- event.page.html %>% html_node("#ctl00_timeLabel") %>% html_text()
     event.location <- event.page.html %>% html_node("#ctl00_locationLabel") %>% xml_contents() %>% .[[1]] %>% html_text()
     event.city <- event.page.html %>% html_node("#ctl00_locationLabel") %>% xml_contents() %>% .[[3]] %>% html_text()
     
     data.frame(event.title = event.title, event.time = event.time, event.city = event.city, event.location = event.location)
}

# TODO: run get_event_details on each link in df, and add to df
