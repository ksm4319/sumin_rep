R.version
package_version(R.version)

.libPaths()

installed.packages() #설치된 패키지
search()
searchpaths()
help(package="ggplot2") #어느 경로에 있는지

install.packages("ggplot2")
update.packages("ggplot2")
remove.packages("ggplot2")
library(ggplot2)





#타입확인
a<-10
a<-"문자"
a<- TRUE
a<-c(1,2,3,4,5,6) #벡터 안에 있는 값의 타입
a<-c('A','B')
a<-matrix(1:6,nrow=2,ncol=3)
a<-array(1:6,dim=c(2,3))
a<-list(c(1,2,3),c('A','B','C'))

#typeof:원시타입(R언어)
#mode:원시타입(S언어)
#class:객체지향적 타입
typeof(a); mode(a);class(a) 

#data frame:list중에 행,열 갯수가 같은 것

english<-c(100,60,90,80,70)
math<-c(100,80,90,90,80)
df1<-data.frame(english,math)
typeof(df1);mode(df1);class(df1);df1
df1$english #들어있는 값
df1$math
df1[1] #dataframe첫번째열
df1[[1]] #dataframe첫번째 열의 값들
df1[[1]][1] #실제값
df1[1,1] #행,칼럼
df1[1,]#행의 모든 칼럼

english<-c(100,60,90,80,70)
math<-c(100,80,90,90,80)
class<-c(1,1,2,2,1)
df1<-data.frame(english,math,class)
df1[1,3]
english_mean<-mean(df1$english);english_mean
math_mean<-mean(df1$math);math_mean


a<-matrix(1:6,nrow=2,ncol=3)
df2<-data.frame(a)
typeof(df2);mode(df2);class(df2);df2

a<-array(1:6,dim=c(2,3))
df3<-data.frame(a)
typeof(df3);mode(df3);class(df3);df3

#혼자서 해보기
제품<-c('사과','딸기','수박')
가격<-c(1800,1500,3000)
판매량<-c(24,38,13)
df4<-data.frame(이름,가격,판매량);df4
price_mean<-mean(df4$가격);price_mean
sell_mean<-mean(df4$판매량);sell_mean


#패키지 설치
install.packages("readxl")
library(readxl)

#dev_R밑에 data폴더 넣어주기
#경로:절대경로(패스full,드라이브~),상대경로(현재폴더기준)
getwd() #working directory
setwd("c:\\dev_R")
setwd("c:/dev_R") #제어문자 \t(tab) \n(newline)
#상대경로
df=read_excel(".\\Data/excel_exam.xlsx")
df=read_excel("./Data/excel_exam.xlsx") #tab치면 문서확인 가능
typeof(df);mode(df);class(df)
df$english
df[20,]

#col_names:칼럼이름부여
df=read_excel("Data/excel_exam_novar.xlsx",col_names = c("A","B","C","D","E"));df
df=read_excel("Data/excel_exam_novar.xlsx",col_names= F); df
df=read_excel("Data/excel_exam_sheet.xlsx",col_names = c("A","B","C","D","E"),sheet=3);df

#csv이용
df<-read.csv("Data/csv_exam.csv");df
df<-read.csv("Data/csv_exam3.csv");df
str(df)

df<-read.csv("Data/SongList.csv",stringsAsFactors = F)
df

#읽기와 쓰기
english<-c(100,60,90,80,70)
math<-c(100,80,90,90,80)
class<-c(1,1,2,2,1)
df1<-data.frame(english,math,class)

#csv파일로 쓰기
write.csv(df1,file="Data/myscore.csv")
#csv파일 읽기
df2=read.csv("Data/myscore.csv");df2

typeof(df2); mode(df2)
class(df2)

#Rdata 파일 활용하기
save(df2,file="Data/my.RDATA")
load("Data/my.RDATA")
df2


a=10
b=20
c=TRUE
ls()
rm(list=ls())

#데이터분석 기초

df=read.csv("Data/csv_exam.csv");df
head(df,n=2) #데이터 앞부분 출력
head(df) #6개
tail(df,n=2) #데이터 뒷부분 출력
tail(df)
View(df)
dim(df) #행,열 출력
str(df) #데이터 속성 확인
df$math[14]
summary(df)

df<-read.csv("Data/SongList.csv",stringsAsFactors = F)
df
str(df)
summary(df)


install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)
mpg
data(mpg)
typeof(mpg);mode(mpg);class(mpg)

df3<-as.data.frame(ggplot2::mpg)
typeof(df3);mode(df3);class(df3)
head(df3,3)
tail(df3,3)

dim(df3)
str(df3)
summary(df3)

paste("점심","메뉴") #공백주고 붙이기
paste(c("점심","메뉴"),collapse="")
paste0("점심","메뉴") #공백없이 붙이기

aa="점심"
paste0(aa,"메뉴")

df4=data.frame(c(100,80,90),c(10,30,100));df4

a=c(100,80,90)
b=c(10,30,100)
df4=data.frame(수학=a,영어=b);df4

rename(df4,math=수학)

df<- as.data.frame(ggplot2::mpg)
df2<-df #복사본 데이터를 이용해서
df2<-rename(df2,city=cty,highway=hwy)

head(df2,2)

df2$sum <- df2$city + df2$highway
df2$avg <- (df2$city + df2$highway)/2
head(df2)

mean((df2$city+df2$highway)/2)
mean(df2$avg)

#요약통계랑...도시연비+고속도로연비
summary(df2$sum)
hist(df2$avg)

df2$test =ifelse(df2$avg>=20,"합격","불합격")
head(df2)

table(df2$test)
table(df2$trans)
table(df2$class)
table(df2$f1)

?mpg

str(df2)

#연비 합격 빈도 막대그래프 생성
table(df2$test)
qplot(df2$test)


df2$grade=ifelse(df2$avg>=30,'A',ifelse(df2$avg>=20,'B','C'))
df2
table(df2$grade)
qplot(df2$grade)

getwd()
df=read.csv("Data/employees2.csv",stringsAsFactors = F);df
str(df)
summary(df)#요약 통계량

table(df$JOB_ID)
qplot(df$JOB_ID)

#문제풀기
df=as.data.frame(ggplot2::midwest);df
str(df)             
#dplyr: rename관련 패키지
df<-rename(df,total=poptotal,asian=popasian)
head(df,2)
df$total[1]
df$asian[1]

df$total1<-df$asian/df$total*100
hist(df$total1)

df$asianavg<-mean(df$total1)
df$avg1=ifelse(df$total1>df$asianavg,'large','small')

table(df$avg1)
qplot(df$avg1)

#6.자유자재로 데이터 가공하기
df=read.csv("Data/csv_exam.csv");df

#class가 1인 row추출
df$class == 1
df[df$class == 1,]
df[c(1,2,3),]
df[c(3,4),]
df[df$class ==1 || df$class==2,]

str(df)
df[,c("class","math")]
df %>%select(class,math)

df %>% filter(class==1 | class==2) #1반 or 2반 인것만 가져오라ㅏ
      select(math,english)
      
df %>% filter(class %in% c(1,2) & english>=90) 
df

#1반과 2반의 평균비교
a=df[df$class==1,c("class","math","english","science")]
b=df[df$class==2,c("class","math","english","science")]

mean( (a$math+a$english+a$science)/3)
mean( (b$math+b$english+b$science)/3)

#dplyr
a=df %>% filter(class==1);a
b=df %>% filter(class==2);b

#혼자서 해보기
#1
df<- as.data.frame(ggplot2::mpg)
a=df[df$displ<=4,];a
a=df %>% filter(displ<=4)
b=df[df$hwy>=5,];b
b=df %>% filter(displ>=5)

m1=mean(a$hwy)
m2=mean(b$hwy)
ifelse(m1>m2,"4이하가 크다",ifelse(m1=m2,"같다","5이상이 크다"))

#2
mean(df[df$manufacturer=="audi","cty"])
mean(df[df$manufacturer=="toyota","cty"])
a1=df %>% filter(manufacturer=='audi') %>% select("cty");a1
b1=df %>% filter(manufacturer=='toyota' );b1

m3=mean(a1$cty);m3
m4=mean(b1$cty);m4

ifelse(m3>m4,"audi가 크다",ifelse(m3==m4,"같다","toyota이 크다"))

total=df %>% filter(manufacturer=="chevrolet"|manufacturer=="ford"|manufacturer=="honda")
total=df %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
total
totalavg=mean(total$hwy)
totalavg
