library(nlme)
library(lme4)
library(emmeans)

rm(list=ls())
dat <- read.table("test.csv", sep = ",", header = T, row.names = 1)

dat$Group = as.factor(dat$Group)
dat$CageID = as.factor(dat$CageID)

datThree = subset(dat, Day == 3)
datSeven = subset(dat, Day == 7)

#day 3
#A for sucrose,B for PGA,C for PC.
levels(datThree$Group) = c("A", "B","C")
threep = glmer(Phenotype ~ Group + (1|CageID), data = datThree, family = "poisson")
summary(threep)
post_hocs_glmm_three <- emmeans(threep, pairwise ~ Group)
summary(post_hocs_glmm_three)

#day 7
#A for sucrose,B for PGA,C for PC.
levels(datSeven$Group) = c("A", "B","C")
sevenp = glmer(Phenotype ~ Group + (1|CageID), data = datSeven, family = "poisson")
summary(sevenp)
post_hocs_glmm_seven <- emmeans(sevenp, pairwise ~ Group)
summary(post_hocs_glmm_seven)






