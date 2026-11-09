# Import the Assignment_7/Utah_Religions_by_County.csv data set
read.csv("Utah_Religions_by_County.csv")
Religions_County <- read.csv("Utah_Religions_by_County.csv")

# Clean it up into “tidy” shape
religions_long <- Religions_County %>% pivot_longer(
  cols = c("Assemblies.of.God", "Episcopal.Church", "Pentecostal.Church.of.God", "Greek.Orthodox", "LDS", "Southern.Baptist.Convention", "United.Methodist.Church", "Buddhism.Mahayana", "Catholic", "Evangelical", "Muslim", "Non.Denominational", "Orthodox"),
  names_to = "Religion",
  values_to = "Perc_Pop"
)
 
# Explore the cleaned data set with a series of figures (I want to see you exploring the data set)
theme_set(theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5)
))
ggplot(data = religions_long, mapping = aes(x = Religion, y = Perc_Pop)) +
  geom_point(mapping = aes(x = Religion, y = Perc_Pop)) +
  facet_wrap(~ County)
  #scatter plots faceted by county. This was to help me visualize what percentage of each religion was going on in each county
  #Not suprising to see that LDS is much higher than the rest of the religions. 

ggplot(data = religions_long, mapping = aes(x = Pop_2010, y = Religious, color = County, group = County)) +
  geom_point(mapping = aes(x = Pop_2010, y = Religious, color = County, group = County))
  #This gives us a nice scatter plot of what percentage of the population is religious and shows all the counties together on one map.

ggplot(data = religions_long, mapping = aes(x = County)) +
  geom_bar(fill = "steelblue")
  #This didn't do what I wanted but I will leave it here for learning

ggplot(data = religions_long, mapping = aes(x = County, y = Pop_2010)) +
  geom_col(fill = "forestgreen")
  #Simply bar graph comparing the population between the counties

ggplot(data = religions_long, mapping = aes(x = County, y = Pop_2010, fill = Religious)) +
  geom_col(position = "dodge")
  #This is showing a color within the gradiant based on what percentage of the population is religious

ggplot(data = religions_long, mapping = aes(x = County, y = Pop_2010, fill = Non.Religious)) +
  geom_col(position = "dodge")
  #Same idea as before but now it's showing non-religious

religions_longer <- religions_long %>%
  pivot_longer(cols = c(Religious, Non.Religious), 
               names_to = "Status", 
               values_to = "Count")
  #Making it longer I guess

ggplot(data = religions_longer, mapping = aes(x = County, y = Count, fill = Status)) +
  geom_col(position = "dodge") +
  labs(title = "Religious vs. Non-Religious Population by County",
       y = "Population")
  #This is my favorite graph yet


# Address the questions:
#   
# “Does population of a county correlate with the proportion of any specific religious group in that county?”
    ##Yes it does seem to be that way. The data is showing that the highest proportion of religious group no matter the county in LDS although what percentage does vary by county. The only county that almost breaks the pattern is summit county.

# “Does proportion of any specific religion in a given county correlate with the proportion of non-religious people?”
    ##Not as far as I can tell but I will admit I'm a bit confused by the question. How would the proportion of religious people correlate with the proportion of non-religious people? Of course they're going to correlate because the two numbers are based off of each other. 




