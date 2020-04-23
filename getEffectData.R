library(tidyverse)
# Add effect data firectly from WOLD cldf sources

datafile = "loanwords_withiconicity_systematicity.csv"
dataloan <- read.csv(datafile,stringsAsFactors = F,encoding = "UTF-8",fileEncoding = "UTF-8")

orig = read.csv("../Stats 2/data/wold-dataset.cldf/wold-vocabulary-13.csv",stringsAsFactors = F)

# Mark words that are definatley not borrowed
orig$effect[orig$Borrowed_score==0] = "Not borrowed"

# Convert to factor, everything else becomes NA
orig$effect2 = factor(orig$effect,levels = c("Not borrowed","Replacement","Coexistence","Insertion"))

# There are multiple cases of some word forms in ids1.csv, one for each meaning type. e.g. "boil" (re:hot water) and "boil" (re:skin). This could cause problems if there are different effects/ dates / borrowing statuses for each meaning. There is only one case where this affects the main data we use. The word "palm" meaning palm of hand, is borrowed from French, while the palm tree is borrowed from Latin. Both are clearly borrowed, so no problem there. But palm of the hand is Coexistance while palm tree is Insertion.  Since it's just one word, we have excluded it.

nEffects = tapply(orig$effect2,orig$Value,function(X){length(unique(X))})
nEffects[nEffects>1]

orig = orig[!orig$Value %in% names(nEffects[nEffects>1]),]

dataloan$effect = orig[match(dataloan$word, orig$Value),]$effect2

write.csv(dataloan,datafile,fileEncoding = "UTF-8")


# grs = gr %>% group_by(!!as.name(fac)) %>% 
#   summarise(ci = list(mean_cl_normal(Replacement) %>%
#                         rename(R=y, R.lwr=ymin, R.upr=ymax)),
#             ci2 = list(mean_cl_normal(Coexistence) %>%
#                          rename(C=y, C.lwr=ymin, C.upr=ymax)),
#             ci3 = list(mean_cl_normal(Insertion) %>%
#                          rename(I=y, I.lwr=ymin, I.upr=ymax))
#   ) %>% unnest(cols=c(ci,ci2,ci3))