#1. Read in the unicef data (10 pts) 
read.csv("unicef-u5mr.csv")
unicef <- read.csv("unicef-u5mr.csv")


#2. Get it into tidy format (10 pts) 
library(tidyverse)
      #rules for tidy:
      #1. Each variable is a column; each column is a variable.
      #2. Each observation is a row; each row is an observation.
      #3. Each value is a cell; each cell is a single value.
unicef_long <- unicef %>% pivot_longer(
  cols = c("U5MR.1950", "U5MR.1951", "U5MR.1952", "U5MR.1953", "U5MR.1954", "U5MR.1955", "U5MR.1956", "U5MR.1957", "U5MR.1958", "U5MR.1959", "U5MR.1960", "U5MR.1961", "U5MR.1962", "U5MR.1963", "U5MR.1964", "U5MR.1965", "U5MR.1966", "U5MR.1967", "U5MR.1968", "U5MR.1969", "U5MR.1970", "U5MR.1971", "U5MR.1972", "U5MR.1973", "U5MR.1974", "U5MR.1975", "U5MR.1976", "U5MR.1977", "U5MR.1978", "U5MR.1979", "U5MR.1980", "U5MR.1981", "U5MR.1982", "U5MR.1983", "U5MR.1984", "U5MR.1985", "U5MR.1986", "U5MR.1987", "U5MR.1988", "U5MR.1989", "U5MR.1990", "U5MR.1991", "U5MR.1992", "U5MR.1993", "U5MR.1994", "U5MR.1995", "U5MR.1996", "U5MR.1997", "U5MR.1998", "U5MR.1999", "U5MR.2000", "U5MR.2001", "U5MR.2002", "U5MR.2003", "U5MR.2004", "U5MR.2005", "U5MR.2006", "U5MR.2007", "U5MR.2008", "U5MR.2009", "U5MR.2010", "U5MR.2011", "U5MR.2012", "U5MR.2013", "U5MR.2014", "U5MR.2015"), 
  names_to = "U5MR.YEAR", 
  values_to = "mortality_rate"
)


#3. Plot each country’s U5MR over time (20 points)
library(ggplot2)

unicef_long$U5MR.YEAR <- as.numeric(gsub("U5MR.", "", unicef_long$U5MR.YEAR))
#Changes the varibales within the year column to be numeric values of the year so that they can be manipulated as numeric values for the labels on the x-axis

ggplot(data = unicef_long, mapping = aes(x = U5MR.YEAR, y = mortality_rate)) +
  geom_line(mapping = aes(x = U5MR.YEAR, y = mortality_rate, group = CountryName)) +
  facet_wrap(~ Continent) +
  scale_x_continuous(
    breaks = c(1960, 1980, 2000),           
    limits = c(1950, 2015)) +
  labs(x = "Year", y = "U5MR")
  

#4. Save this plot as LASTNAME_Plot_1.png (5 pts) 
##Done!


#5. Create another plot that shows the mean U5MR for all the countries within a given continent at each year (20 pts)
ggplot(data = unicef_long, mapping = aes(x = U5MR.YEAR, y = mortality_rate, color = Continent, group = Continent)) + 
  stat_summary(fun = mean, geom = "line", linewidth = 2) + #this line is crutial to create the smooth lines for each continent by only plotting the mean of all years combined rather than trying to connect the points for every year from each country
  scale_x_continuous(breaks = c(1960, 1980, 2000), limits = c(1950, 2015)) + 
  labs(x = "Year", y = "Mean.U5MR", color = "Continent") +
  theme_bw()

#6. Save that plot as LASTNAME_Plot_2.png (5 pts) 
##Done!


#7. Create three models of U5MR (20 pts)
        #- mod1 should account for only Year
        #- mod2 should account for Year and Continent
        #- mod3 should account for Year, Continent, and their interaction term
library(modelr) 
options(na.action = na.warn)
#install.packages("lme4")  #use this line if the package isn't installed
library(lme4)

mod1 <- lm(mortality_rate ~ U5MR.YEAR, data = unicef_long)
summary(mod1)

unicef_long$Continent <- as.factor(unicef_long$Continent)
#ensures that the continent comlumn is being treated like a factor so the models run correctly

mod2 <- lm(mortality_rate ~ U5MR.YEAR + Continent, data = unicef_long)
summary(mod2)
#assumes the data is parallel and changes equally over time

mod3 <- lm(mortality_rate ~ U5MR.YEAR*Continent, data = unicef_long)
summary(mod3)
#changes to account for the different changing rates within each continent


#8. Compare the three models with respect to their performance
anova(mod1, mod2, mod3)
      ##I think that the mod3 would be the best because it takes into account the different changing rate for each continent. In a perfect world, each continent would express the same rate of change and mod2 would suffice but that is often not the case in the real world. So applying a model that tries to factor the different rates of change would produce the most accurate model. 


#9. Plot the 3 models’ predictions like so: (10 pts)
grid <- unicef_long %>%
  data_grid(U5MR.YEAR = seq_range(U5MR.YEAR, n = 100), Continent)
#Generate as a grid of years and continents to create smooth prediction lines

grid_preds <- grid %>%
  add_predictions(mod1, var = "mod1") %>%
  add_predictions(mod2, var = "mod2") %>%
  add_predictions(mod3, var = "mod3")
#takes predictions from the models and adds it to the grid

plot_data <- grid_preds %>% pivot_longer(
    cols = c(mod1, mod2, mod3), 
    names_to = "Model", 
    values_to = "Predicted_U5MR"
  )
#makes it tidy

ggplot(plot_data, aes(x = U5MR.YEAR, y = Predicted_U5MR, color = Continent)) +
  geom_line(linewidth = 1) +  # Draws the predicted regression lines
  facet_wrap(~ Model) + 
  labs(
    title = "Model predictions",
    x = "Year",
    y = "Predicted U5MR",
    color = "Continent"
  ) +
  theme_bw()