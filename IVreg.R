library(readstata13)
library(stargazer)
library(AER)
install.packages("visreg")
library(visreg)
inout = "E:/EcoApli/Research/Project/Out"
regdat<-read.dta13(paste(inout, "data_reg.dta", sep="/"))

#Intrumento valido??
inslm3<-lm(data = regdat,l_diffnat00~l_gin00+edu_mean00+gubgas+l_ing00+l2_ing00+
            R02+R03+R04+R05+R06+R07+R08+R09+R10+R11+R12+R13+R14+R15+R16+R17+R18+R19+R20+R21+R22+R23+
            R24+R25+R26+R27+R28+R29+R30+R31+R32)
inslm2<-lm(data = regdat,l_diffnat00~l_gin00+edu_mean00+gubgas+l_ing00+l2_ing00)
inslm1<-lm(data = regdat,l_diffnat00~l_gin00+edu_mean00+gubgas)
stargazer(inslm1,inslm2,inslm3)
#Ahora IV

iv1<-ivreg(data = regdat,crec_Y~l_diffnat00+edu_mean00+gubgas,~l_gin00+
             edu_mean00+gubgas)

iv2<-ivreg(data = regdat,crec_Y~l_diffnat00+edu_mean00+gubgas+l_ing00+l2_ing00,~l_gin00+
             edu_mean00+gubgas+l_ing00+l2_ing00)

iv3<-ivreg(data = regdat,crec_Y~l_diffnat00+edu_mean00+gubgas+l_ing00+l2_ing00+
             +R02+R03+R04+R05+R06+R07+R08+R09+R10+R11+R12+
             R13+R14+R15+R16+R17+R18+R19+R20+R21+R22+R23+
             R24+R25+R26+R27+R28+R29+R30+R31+R32,~l_gin00+
             edu_mean00+gubgas+l_ing00+l2_ing00+R02+R03+R04+R05+R06+R07+R08+R09+R10+R11+R12+
             R13+R14+R15+R16+R17+R18+R19+R20+R21+R22+R23+
             R24+R25+R26+R27+R28+R29+R30+R31+R32)

stargazer(iv1,iv2,iv3)
summary(iv3, vcov = sandwich, diagnostics = TRUE)
##Visualizacion
a<-lm(data = regdat,crec_Y~exp(l_diffnat00)+gini0505)
visreg(iv1)
visreg2d(a,xvar="gini0505",yvar="l_diffnat00",type="contrast")

         