
## @knitr init, eval=FALSE
## library(ProjectTemplate)
## create.project('bicdata')
## setwd("bicdata/")
## load.project()
## 


## @knitr init2, eval=FALSE
## #copy titanic to data dir
## titanic <- read.csv("http://dl.dropbox.com/u/8686172/titanic.csv")
## write.csv(titanic, file="data/titanic.csv")
## 
## load.project()
## 
## #modify munging process
## #modify config file
## 
## #load.project()
## 
## show.project()
## 


## @knitr init3, eval=FALSE
## stub.tests()
## 
## #needs to be modified to "test-*.R"
## test.project()


## @knitr init4, eval=FALSE
## # if logging : on
## warn(logger, "This is warning")
## scan("logs/project.log", what="character")
## 


## @knitr ggplot2, warning=FALSE, message=FALSE, fig.height=6 , fig.width=7
library(ggplot2)

# 서로 다른 표현
qplot(carat, price, data = diamonds, geom="point" ,colour=clarity) # (1)
ggplot(data=diamonds, aes(x=carat,y=price)) + geom_point(aes(colour=clarity))# (2)

# 매핑 정보 및 각종 정보들을 보여줌
s <- ggplot(data=diamonds, aes(x=carat,y=price)) 
summary(s)

# 미적 요소 매핑의 오버라이딩 
ggplot(data=diamonds, aes(x=carat,y=price)) + geom_point(aes(colour=clarity)) + 
  geom_smooth() #  (1)

ggplot(data=diamonds, aes(x=carat,y=price, colour=clarity)) +
  geom_point() + geom_smooth() #  (2)

#set기능으로 색상 적용 
#http://research.stowers-institute.org/efg/R/Color/Chart/
ggplot(data=diamonds, aes(x=carat,y=price, colour=clarity))+ geom_point(colour="darkblue")

# group 매핑 
p <- ggplot(data=diamonds, aes(x=carat,y=price))
p + geom_smooth() #  (1)
p + geom_smooth(aes(group=clarity)) #  (2)

# geom과 stat 객체 
ggplot(data=diamonds, aes(x=price)) + geom_bar() #  (1)
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(y=..count..)) #  (2)
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(y=..density..))
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(y=..ncount..))
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(y=..ndensity..))
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(y=..density..)) + ylab("밀도")


#위치 조정 

ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(fill=cut), binwidth=3000)
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(fill=cut), binwidth=3000, position="dodge")
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(fill=cut), binwidth=3000, position="fill")

#facet
ggplot(data=diamonds, aes(x=price)) + geom_bar(binwidth=3000) + facet_grid( . ~ cut)
ggplot(data=diamonds, aes(x=price))+ geom_bar(binwidth=3000) + facet_wrap( ~ cut,nrow=3)

#geom과 stat의 결합 
d <- ggplot(diamonds, aes(price))
d + stat_bin(geom="bar")
d + stat_bin(geom="area")
d + stat_bin(aes(size=..ndensity..),geom="point")
d + stat_bin(aes(y=1, fill=..density..),geom="tile")



#레이블 및 텍스트 
ggplot(data=diamonds, aes(x=price)) + geom_bar(aes(fill=cut), binwidth=3000, position="fill") + 
  xlab("가격") + ylab("빈도") + 
  scale_fill_discrete("커팅") + 
  theme(axis.text.x=element_text(angle=90, vjust=.4))



## @knitr plyr
library(ggplot2)
library(plyr)

market_price <- read.csv("https://dl.dropbox.com/u/8686172/marketprice.csv", fileEncoding="UTF-8")



# ggplot(market_price, aes(x=A_NAME, y=A_PRICE, colour=M_TYPE_NAME)) +
#   geom_boxplot(outlier.size=0) +
#   stat_summary(aes(group=M_TYPE_NAME),fun.y="mean", geom="line", size=1, alpha=I(0.7))+
#   opts(axis.text.x=theme_text(angle=90))

ddply(market_price, .(A_NAME, M_TYPE_NAME), summarize, mean_price=mean(A_PRICE) )



## @knitr domc, echo=TRUE,eval=FALSE
## #멀티코어사용
## 
## library(doSNOW)
## cl <- makeCluster(c("localhost","localhost"), type = "SOCK")
## registerDoSNOW(cl)
## 
## system.time({
##   a1<-ddply(market_price, .(A_NAME, M_TYPE_NAME), summarize, mean_price=mean(A_PRICE) )
## })
## 
## system.time({
##   a2<- ddply(market_price, .(A_NAME, M_TYPE_NAME), summarize, mean_price=mean(A_PRICE),.parallel=TRUE)
## })
## 
## stopCluster(cl)
## 
## 
## #for Linux on my case
## library(doMC)
## registerDoMC()
## 
## system.time({
##   a3<- ddply(market_price, .(A_NAME, M_TYPE_NAME), summarize, mean_price=mean(A_PRICE),.parallel=TRUE)
## })
## 


## @knitr datatable
library(data.table)

market_price.dt <- data.table(market_price) #--- (1)

market_price.dt[2,list(M_NAME)] #--- (2) 

market_price[2,"M_NAME",drop=F]

market_price.dt[,list(avg = mean(A_PRICE)), by=list(M_TYPE_NAME, A_NAME)]


setkey(market_price.dt, A_NAME)
market_price.dt['고등어']
head(market_price.dt)
setkey(market_price.dt)


market_price.dt[A_NAME == '고등어',]
#market_price.dt['고등어']
head(market_price.dt)





## @knitr reshape2

library(reshape2)

head(iris)

iris.melt <- melt(iris, id="Species", value.name = "cm")

head(iris.melt)

ggplot(iris.melt, aes(Species, cm)) + geom_point(aes(colour=variable)) + scale_color_discrete("Species")


## @knitr lub_error, eval=FALSE
## library(lubridate)
## 
## Sys.getlocale("LC_TIME")
## # [1] "Korean_Korea.949"
## 
## ymd("2013-01-03")
## # 다음에 오류gsub("+", "*", fixed = T, gsub(">", "_e>", num)) : '<ec><98><a4>?<84>|<ec>삤<ed>썑)(?![[:alpha:]]))|((?<h_f_e>2[0-4]|[01]?\d)\D+(?<m_f_e>[0-5]?\d)\D+((?<os_f_s_e>[0-5]?\d\.\d+)|(?<s_f_e>[0-6]?\d))))'에 잘못된 멀티 바이트 문자가 있습니다
## 
## Sys.setlocale("LC_TIME", "C")
## # [1] "C"
## ymd("2013-01-03")
## # 1 parsed with %Y-%m-%d
## # [1] "2013-01-03 UTC"
## 
## 
## 
## Sys.setlocale("LC_TIME", "Korean_Korea.949")
## format(Sys.time(), "%a %b %d %X %Y %Z")
## # [1] "목 1 03 오후 2:26:21 2013 KST"
## 
## Sys.setlocale("LC_TIME", "C")
## format(Sys.time(), "%a %b %d %X %Y %Z")
## # [1] "Thu Jan 03 14:26:34 2013 KST"


## @knitr lubridate
library(lubridate)

x <- c(20090101, "2009-01-02", "2009 01 03", "2009-1-4",
       "2009-1, 5", "Created on 2009 1 6", "200901 !!! 07")
y <- ymd(x)


y

y + days(1) + hours(6) + minutes(30)

y - months(12)


## @knitr knitr, eval=FALSE
## library(knitr)
## 
## knit("bicdata.Rmd", encoding="UTF-8")
## 
## system("pandoc -o test.docx test.md")
## 


