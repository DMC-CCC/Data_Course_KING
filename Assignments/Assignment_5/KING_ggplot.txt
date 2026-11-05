library(ggplot2)
library(ggthemes)
library(stringr)
options(scipen = 999)                  # turn off scientific notation like 1e+06
data("midwest", package = "ggplot2")            # load the data


theme_set(theme_wsj() + 
            theme(
              axis.title = element_text(),
              axis.title.x = element_text(size = 20, angle = 5, face = "bold", margin = margin(t = 10)), #picks the size and placement of the x-axis title
              axis.title.y = element_text(size = 5, face = "bold", margin = margin(r = 10)), #picks the size and placement of the y-axis title
              axis.text.y = element_text(angle = 160, vjust = 0.5, color = "yellow"), #adjusts the angle, alignment, and color of the y-axis labels
              axis.text.x = element_text(angle = 131, vjust = 0.3), #adjusts the angle and alignment of the x-axis labels
              plot.title = element_text(size = 50, hjust = 0.8, color = "red1"), #moves the title to the left and adjusts the size and color
              plot.background = element_rect(fill = "magenta"), #changes the color of the entire plot
              panel.background = element_rect(fill = "lightslateblue") #changes the color of just the graph
            ))
#This sets the theme for the graph. I figured Wall Street Journal would be atrocious enough for this assignment.
#All of the extra junk is needed because the default for this theme does not show axis titles and I wanted them to be there.

ggplot(midwest, aes(x = county, y = perchsd)) + 
  geom_point(aes(color = perchsd), size = 6.7) + #assigns the color gradiant to the perchsd colomn *must be a neumerical value
  geom_line() + #literally just added this to create more chaos
  scale_color_gradient(low = "green", high = "mediumspringgreen", guide = "none") + #adds color to the points and removed the gradient legend
  labs(title="Some Data From the Devil's Arsehole", 
       subtitle="JK I *REDACTED* the Midwest", 
       y= "", 
       x="% of Cr0t(h gOB1!n$ [y-axis}", caption= "I hope this graph makes u ??? the purpose of life") +
  guides(x = guide_axis(n.dodge = 3)) + #this line creates the three columns for the x-axis labels
  labs(y = str_wrap("This is an all inclusive list [probably but I didn't fact check} of all 437 counties in the 5 different midwestern states that existed at the time of the collection of this data set [x-axis}", 
                    width = 120))
#The labs code wraps the label for the y-axis because it was too long