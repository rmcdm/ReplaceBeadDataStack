library(dplyr)
library(readr)

#Load in original data - don't forget to change paths!
Bead_Data_qPCR <- read.csv("E:/Phoenix images/November/107-2/DataROI4/Bead Data-qPCR.csv", check.names = FALSE)

#Adjust sample lane numbers to remove whichever sample lanes need to be removed
BeadDataqPCR <- subset(Bead_Data_qPCR, `Sample Lane` != 5 & `Sample Lane` != 6)

#Load in re-stacked subarray(s)  - don't forget to change paths!
Bead_Data_qPCR_6 <- read.csv("E:/Phoenix images/November/107-2/DataROI4/Stack 6 Bead Data ROI4-qPCR.csv", check.names =  FALSE)

#combine the subset & restack files
BeadDataqPCR_Fixed <- bind_rows(BeadDataqPCR, Bead_Data_qPCR_6)

#Verify bead counts haven't changed
counts1 <- Bead_Data_qPCR %>%
  count(`Sample Lane`) %>%
  rename(.,"SampleLane" = 1) %>%
  rename(.,"Original" = 2)

counts2 <- BeadDataqPCR %>%
  count(`Sample Lane`) %>%
  rename(.,"SampleLane" = 1) %>%
  rename(.,"Change1" = 2)

counts3 <- BeadDataqPCR_Fixed_ROI3 %>%
  count(`Sample Lane`) %>%
  rename(.,"SampleLane" = 1) %>%
  rename(.,"Final" = 2)

#Combine the three checks in to one table
check <- merge(counts1, counts2, by = "SampleLane", all = TRUE)
check <- merge(check, counts3, by = "SampleLane")

#If checked table is ok, write the fixed bead data table to a csv - don't forget to change paths!
if(all(check["Original"] == check["Final"])) {
  write.csv(BeadDataqPCR_Fixed_ROI3, "E:/Phoenix images/November/107-2/Data/Bead Data-qPCR-fixed-ROI4.csv", row.names=FALSE)
  print("Fixed your bead data file!")
  } else {
  check
  print("Check the verification table.")
  }
