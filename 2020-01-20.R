v1=c(1,2,"3",4,5)
v1
#하나의 칼럼은 같은 타입이 된다.
typeof(v1);mode(v1);class(v1)

#데이터 프레임을 생성하는 방법
id = 1:5 
age= c(29, 32, 47, 35, 23) 
name=c("재은","지인","수연","시은","원식")
gender = c("f", "m", "m", "f", "f")
gender2=factor(gender,levels=c("m","f"),labels=c("남","여"))
height = c(163, 177, 172, 157, 169)
df1 = data.frame(id, age, gender2, height,name)
typeof(df1);mode(df1);class(df1)
is.data.frame(df1)
str(df1)
levels(df1$gender)
df1

#stringAsfactors: 데이터 유형이 문자형인 경우 factor로 변경되는데 원하지 않을 경우 false
df2 = data.frame(id, age, gender, height, name, stringsAsFactors=FALSE)
str(df2)
df2$gender=as.factor(df2$gender)
nrow(df2) #5
ncol(df2) #5


rownames(df2)=paste0("R",1:5)
rownames(df2)
colnames(df2)
dim(df2)

getwd() 


df1=read.table(file="Data/csv_exam_blank.txt",sep=" ",header=T);df1
df2=read.table(file="Data/csv_exam_tab.txt",sep="\t",header=T);df2
df3=read.table(file="Data/csv_exam.csv",sep=",",header=T);df3
df4=read.csv(file="Data/csv_exam.csv");df4

library(readxl)
df5=read_excel(path = "Data/excel_exam.xlsx");df5

save(df5,file="aa.RDATA")
save.image(file="bb.Rdata")

load("aa.RDATA")
load("bb.Rdata")

ls()
rm(df1)
rm(list=ls())

library(ggplot2)
df=as.data.frame(ggplot2::diamonds)
str(df)
view(df)
head(df,3)
tail(df,3)

df[10,1]
df[1000,1]
df[,1,drop=F]
df[,c(1,5)]
df[,1:2]

df[1,]
df[1,c("carat","color")]
head(df[,grep("^c",colnames(df))],5) #c로 시작하는 것
head(df[,grep("c",colnames(df))],5) #c가 포함되어 있는 것
head(df[,grep("t$",colnames(df))],5) #t로 끝나는 것
head(df[,c(1,2),5])
df[,"cut"]

df[diamonds$cut=="Fair",c("color","clarity")]
df2=df[df$cut=="Fair"& df$color=='G',c("color","clarity")]

#pipe
library(dplyr)
df3=df %>% filter(cut=="Fair" & color== 'G')
nrow(df2);
nrow(df3);
ifelse(nrow(df2)==nrow(df3),"같다","같지 않다")

colnames(df)

#파생변수 만들기
df$xyz.sum=df$x+df$y+df$z
df$xyz.mean=(df$x+df$y+df$z)/3

df[1:5,c("x","y","z","xyz.sum","xyz.mean")]

#파생변수 추가
df <- %>%  mutate(xyz.sum2=x+y+z,xyz.mean2=(x+y+z)/3)
head(df,3)

df[1,]
df[-1,]
df[c(1:5)]
df[-c(1:5),]
df[1,c("carat","cut")]

df=read.csv("Data/csv_exam.csv")

table(df$class)
df %>% filter(class==1|class==2)
   %>% select(-class,-math)
   %>% head(4)

str(mpg)
df_mpg=as.data.frame(ggplot2::mpg)
df2=df %>% select(class,cty);df2
df3=df[,c("class","cty")];df3

#혼자서 해보기
df_suv= df2 %>% filter(class=="suv");df_suv
df_compact=df2 %>% filter(class=="compact");df_compact
a=mean(df_suv$cty);
b=mean(df_compact$cty)
ifelse(a<b,"compact가 크다",ifelse(a==b,"같다","suv가 크다"))
       
#오름차순 정렬
exam =read.csv("Data/csv_exam.csv")
#수학점수가 작은 사람부터
exam %>% arrange(desc(class),math)       

#filter,select,arrange

exam %>% filter(class==1) %>% 
  select(class,math) %>% 
  arrange(desc(math))

#혼자서 해보기
str(mpg)

df_mpg %>% filter(manufacturer=="audi") %>% 
  select(manufacturer,hwy) %>% 
  arrange(desc(hwy)) %>% 
  head(5)

head(df_mpg[order(df_mpg$manufacturer=="audi",decreasing = T),c("manufacturer","hwy")]

exam %>% filter(class==1) %>% 
    select(-id) %>% 
    mutate(sum=math+english+science,
          avg=(math+english+science)/3,
          test=ifelse(science>=60,"sucess","fail") %>%         
            arrange(desc(sum))

#혼자서 해보기
df_mpg %>%  mutate(sum=cty+hwy,avg=(cty+hwy)/2) %>% head(2)
df_mpg %>%  mutate(avg=(cty+hwy)/2) %>% arrange(desc(avg)) %>% head(3)

  
mpg %>% mutate(total =cty+hwy,avg=total/2) %>% 
        select(manufacturer,drv,cty,hwy,total,avg) %>% 
        arrange(desc(avg)) %>% head(3)


#집단별로 요약하기
exam %>% group_by(class) %>% 
    summarise(sum_math=sum(math),
              avg_math=avg(math).
              cnt=n(),
              max_math=max(math),
              min_math=min(math)
              )

min(exam[exam$class==1,'math'])
max(exam[exam$class==1,'math'])
length(exam[exam$class==1,'math'])
sum(exam[exam$class==1,'math'])
mean(exam[exam$class==1,'math'])

v1=c(1,2,3,4,5)
sum(v1)
mean(v1)
length(v1)

df_mpg %>% group_by(manufacturer,drv) %>% 
      summarise(count=n(),mean_cty=mean(cty)) %>% 
    arrange(desc(count))

df_mpg %>% group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(total=mean(hwy+cty)) %>% #파생변수(건당)
  summarise(total_mean=meam(total)) %>% 
  arrange(desc(total_mean)) %>% 
  head(5)

df_mpg %>% group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  summarise(total_mean=mean((hwy+cty)) %>% 
  arrange(desc(total_mean)) %>% 
  head(5)

#혼자서 해보기

df_mpg %>%  group_by(class) %>% 
    summarise(mean_cty=mean(cty))


df_mpg %>%  group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty))
max(df$mean_cty); 
df$mean_cty[1]
min(df$mean_cty); 
nrow(df)
df$mean_cty[nrow(df)]


df_mpg %>% group_by(manufacturer) %>% 
          summarise(mean_hwy=mean(hwy)) %>% 
          arrange(desc(mean_hwy)) %>% 
          head(3)

df_mpg %>% group_by(manufacturer) %>% 
          filter(class=="compact") %>% 
        summarise(count=n()) %>% 
        arrange(desc(count))


# 중간고사 데이터 생성
test1 <- data.frame(id = c(1, 2, 3, 4, 5),
                    midterm = c(60, 80, 70, 90, 85))

# 기말고사 데이터 생성
test2 <- data.frame(id = c(1, 2, 3, 4, 5),
                    final = c(70, 83, 65, 95, 80))

#칼럼으로 합치기(id기준으로 합치기)
left_join(test1,test2,by="id")

exam


#반별 담임교사 생성
name <- data.frame(class = c(1, 2, 3, 4, 5),
                   teacher = c("kim", "lee", "park", "choi", "jung"))


left_join(exam,names,by="class")

# 학생 1~5번 시험 데이터 생성
group_a <- data.frame(id = c(1, 2, 3, 4, 5),
                      test = c(60, 80, 70, 90, 85)
                      test3 = c(60, 80, 70, 90, 85)
                      )

# 학생 6~10번 시험 데이터 생성
group_b <- data.frame(id = c(6, 7, 8, 9, 10),
                      test = c(70, 83, 65, 95, 80),
                      test2 = c(70, 83, 65, 95, 80)
                      )

#칼럼이름이 다르면 NA로 들어간다
group_all=bind_rows(group_a,group_b)


#혼자서 해보기
fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22),
                   stringsAsFactors = F)
fuel  # 출력


df_join=left_join(df_mpg,fuel,by="fl")
df_join

df_join %>% select(model,fl,price_fl) %>% 
  head(5)


#분석도전

df_midwest=as.data.frame(ggplot2::midwest);df_midwest

#dplyr
df_midwest =df_midwest %>% 
        mutate(popchilds=(poptotal-popadults)/poptotal *100)
df_midwest

#base
df_midwest$popchild2=(df_midwest$poptotal-df_midwest$popadults)/df_midwest$poptotal*100
df_midwest

df_midwest %>% arrange(desc(popchilds)) %>% 
    select(county,popchilds) %>% 
  head(5)

df_midwest=df_midwest %>% mutate(grade=ifelse(popchilds>=40,"large",ifelse(popchilds>=30,"middle","small")))
table(df_midwest$grade) #table당 몇개씩 들어갔는지 확인할때 table

nrow(df_midwest)
colnames(df_midwest)

df_midwest=df_midwest %>%  mutate(popasian_avg=popasian/poptotal*100)
df_midwest %>% select(state,county,popasian_avg) %>% arrange(popasian_avg)%>% head(10)


df=read.csv(url("https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"),header=F)

str(df)
nrow(df)


df=rename(df,test1="V1",test2="V2",test3="V3",test4="V4")
colnames(df)

install.packages("reshape")
library(reshape)

colnames(df)
df=dplyr::rename(df,c("V1"="test2","V2"="test3"))
str(df)
colnames(df)=c("test1","test2","test3","test4","test5")
colnames(df)

#<데이터 정제>

#결측치 찾기
df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))
df

sum(df$score) #갯수를 알고 싶을 때

is.na(df)

table(is.na(df$sex))
table(is.na(df$score))
table(!is.na(df$score))

#TRUE-->0  FALSE-->0
a=c(TRUE,TRUE,FALSE)
sum(a)

#결측치 제거
a=df %>% filter(!is.na(sex)& !is.na(score))
b=na.omit(df)
c=df %>% filter(!is.na(score))

sum(a$score)
sum(b$score)
sum(df$score)
sum(c$score)
#score칼럼이 na가 아니다.
sum(df$score,na.rm=T)


df_emp=read.csv("Data/employees.csv",stringsAsFactors = F)
nrow(df_emp)

df_emp[!is.na(df_emp$SALARY),]
str(df_emp)
table(is.na(df_emp))

#정제(employees,departmens)
#조인으로 합치기


table(is.na(df_emp))
str(df_emp)

table(is.na(df_emp$COMMISSION_PCT))
table(is.na(df_emp$MANAGER_ID))
table(is.na(df_emp$DEPARTMENT_ID))
df_emp=df_emp %>% filter(!is.na(COMMISSION_PCT)&!is.na(MANAGER_ID)&!is.na(DEPARTMENT_ID))
df_emp

df_dep=read.csv("Data/departments.csv",stringsAsFactors = F)
df_dep
df_dep=df_dep %>% filter(!is.na(MANAGER_ID))
df_dep
df_join2=left_join(df_dep,df_emp,by="DEPARTMENT_ID")
df_join2
