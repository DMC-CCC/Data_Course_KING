#I.
read.csv("cleaned_covid_data.csv") 
    #this is to read the data set so that it can be turned into a dataframe
Covid_Data = read.csv("cleaned_covid_data.csv") 
    #this creates the dataframe and assigns it the name Covid_Data

#II.
A_states = Covid_Data[grepl("^A",Covid_Data$Province_State),] #this step creates the new data frame that is filtered 
                                                              #to be only the A states
print(A_states) #this function will display the new filtered data

#III.
A_states$Last_Update = ymd(A_states$Last_Update) #this changes the class of the Last_Update column to date
class(A_states$Last_Update)
ggplot(
  data = A_states,
  mapping = aes(x = Last_Update, y = Deaths)
) +
  geom_point() +
  geom_smooth(method = "loess", se = TRUE)+
  facet_wrap(~Province_State, scales = "free")
  
#IV
state_max_fatality_rate = Covid_Data%>%
  group_by(Province_State) %>%
  summarise(Case_Fatality_Ratio = max(Case_Fatality_Ratio, na.rm = TRUE))
state_max_fatality_rate = state_max_fatality_rate |> rename(Maximum_Fatality_Ratio = Case_Fatality_Ratio)
arrange(state_max_fatality_rate, desc(Maximum_Fatality_Ratio))

#V
ggplot(
  data = state_max_fatality_rate,
  mapping = aes(x = reorder(Province_State, -Maximum_Fatality_Ratio), y = Maximum_Fatality_Ratio)
) +
  geom_bar(stat = "identity", fill = "green")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))+
  labs(x = "Province_State", y = "Maximum_Fatality_Ratio")
  