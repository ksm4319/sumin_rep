#정제(employees,departmens)
#조인으로 합치기

str(df_emp)


df_emp=read.csv("Data/employees.csv",stringsAsFactors = F)
nrow(df_emp)
df_emp[1,]
table(is.na(df_emp))
df_emp[f_emp$FIRST_NAME==""]
table(is.na(df_emp$SALARY))


#filter
library(dplyr)
a=df_emp %>% filter(!is.na(SALARY))
na.omit(df_emp$SALARY)

df_emp=df_emp[complete.cases(df_emp$SALARY),] #salary=null이 아닌 것만 나와라
nrow(df_emp)
head(df_emp)
sum(df_emp$SALARY)
mean(df_emp$SALARY)

df_dep=read.csv("Data/departments.csv",stringsAsFactors = F)
df_dep=df_dep %>% filter (DEPARTMENT_ID>=10 & DEPARTMENT_ID <300)

colnames(df_emp) #column의 이름이 몇개인지
colnames(df_dep)
nrow(df_dep)


table(is.na(df_emp$COMMISSION_PCT))
table(is.na(df_emp$MANAGER_ID))
table(is.na(df_emp$DEPARTMENT_ID))
df_emp=df_emp %>% filter(!is.na(COMMISSION_PCT)&!is.na(MANAGER_ID)&!is.na(DEPARTMENT_ID))

df=left_join(df_emp,df_dep,by="DEPARTMENT_ID")
df_backup=df
head(df,3)

df %>% select(FIRST_NAME,SALARY,DEPARTMENT_NAME)

str(df_dep)
str(df_emp)

#factor로 가져오기
df %>%mutate(title=ifelse(is.na(DEPARTMENT_NAME),'부서없음',DEPARTMENT_NAME)) %>% 
  select(FIRST_NAME,SALARY,DEPARTMENT_NAME,title)


gender=c("m","f","m","m","f")
typeof(gender); mode(gender);class(gender)

#한정적 목록: factor...명목형
gender2=factor(gender,levels=c("m","f"),labels=c("남","여"))
typeof(gender2); mode(gender2); class(gender2)

labels(gender2) #factor로 온다
levels(gender2)


df=df %>% 
  mutate(COMMISSION_PCT=ifelse(is.na(COMMISSION_PCT),0,COMMISSION_PCT)) 
nrow(df)
colnames(df)


#부서별 직책별 직원들의 급여합계
nrow(df)
df %>%  group_by(DEPARTMENT_NAME,JOB_ID) %>% 
  summarise(total= sum(SALARY),
            total2 = sum(SALARY+SALARY*COMMISSION_PCT)
  ) %>%
  arrange(desc(total))%>% head(5)

df %>% filter(DEPARTMENT_NAME=='Sales') %>% 
      select(DEPARTMENT_NAME,COMMISSION_PCT)



#summarise()에서 na.rm=T 사용하기
df_exam=read.csv("Data/csv_exam.csv")
df_exam[c(3, 8, 15), "math"] <- NA #결측치 만들기
table(is.na(df_exam$math)) #결측치 확인
mean(df_exam$math,na.rm=T) #na제외하고 평균값 구하기


df_exam %>% 
        filter(!is.na(math)) %>%     
        summarise(total=sum(math,na.rm = T),
                      avf=mean(math,na.rm=T)
                      )

#NA에 대해 대체하기

mean(df_exam$math)

df_exam=df_exam %>% 
    mutate(math=ifelse(is.na(math),mean(math,na.rm=T),math))

#혼자서 해보기
df_mpg<-as.data.frame(ggplot2::mpg)
df_mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA  

mpg=ggplot2::mpg

#1
table(is.na(df_mpg$drv))
table(is.na(df_mpg$hwy))

#2
df_mpg %>% filter(!is.na(hwy)) %>% 
      group_by(drv) %>% 
      summarise(hwy_avg=mean(hwy))

#이상치 제거하기
outlier <- data.frame(sex = c(1, 2, 1, 3, 2, 1),
                      score = c(5, 4, 3, 4, 2, 6))

#이상치 확인하기
table(outlier$sex)
table(outlier$score)

#이상치를 결측으로 바꾸기
#방법1
outlier$sex=ifelse(outlier$sex==3,NA,outlier$sex)

#방법2
#mutate는 변수를 추가하거나 수정
outlier= outlier %>%  mutate(ifelse(sex==3,NA,sex))

outlier=outlier %>% mutate(score=ifelse(score>5,NA,score))

#결측모드제거
#방법1
na.omit(outlier)
#방법2
outlier %>% filter(!is.na(sex)&!is.na(score))
#방법3
df_score=outlier[complete.cases(outlier),]
mean(df_score$score)

outlier %>% filter(!is.na(sex)&!is.na(score)) %>% 
          group_by(sex) %>% 
          summarise(mean_score=mean(score))


boxplot(mpg$hwy)
hwy_stats=boxplot(mpg$hwy)$stats

mpg=ggplot2::mpg
df_mpg=as.data.frame(ggplot2::mpg)
table(df_mpg$hwy)
table(is.na(df_mpg))

#이상치를 찾아서 결측으로 대체하기
#통계치를 이용해서 이상치를 찾기
boxplot(df_mpg$hwy)$stats

aa=ifelse(mpg$hwy<hwy_stats[1]|mpg$hwy>hwy_stats[5],NA,mpg$hwy)
table(is.na(aa))

complete.cases(aa)
aa[!complete.cases(aa)]

#이상치찾아서 결측처리하기
df_mpg %>% mutate(hwy=ifelse(hwy<hwy_stats[1]| hwy>hwy_stats[5],NA,hwy))
table(is.na(df_mpg$hwy))
df_mpg[is.na(df_mpg$hwy),]

nrow(df_mpg)

df_mpg %>% group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm=T))

#dr가 f인 hwy의 mean
mean(df_mpg[df_mpg$drv=='f',"hwy"],na.rm=T)


mpg <- as.data.frame(ggplot2::mpg)                  # mpg 데이터 불러오기
mpg[c(10, 14, 58, 93), "drv"] <- "k"                # drv 이상치 할당
mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42)  

#혼자서 해보기
#1
table(mpg$drv)
mpg$drv=ifelse(mpg$drv %in% c('4','f','r'),mpg$drv,NA)

#2
st=boxplot(mpg$cty)$stats

table(is.na(mpg$cty))

mpg$cty=ifelse(mpg$cty<st[1]| mpg$cty>st[5],NA,mpg$cty)

#complet.cases(drv)
#!is.na(drv)
#3
mpg %>% 
  filter(complete.cases(drv)) %>% 
  group_by(drv) %>% 
  summarise(mean_cty=mean(cty,na.rm=T))


#8.그래프 만들기
#산점도 그래프 만들기

nrow(mpg)
library(ggplot2)

ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point()+
  xlim(3,6)+
  ylim(10,30)


#혼자서 해보기
ggplot(data=mpg,aes(x=cty,y=hwy))+
  geom_point()

options
ggplot(data=midwest,aes(x=poptotal,y=popasian))+
    geom_point()+
    xlim(0,500000)+
    ylim(0,10000)


df_mpg<-mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))

ggplot(data=df_mpg,aes(x=reorder(drv,-mean_hwy),y=mean_hwy))+
  geom_col(fill="purple")+
  theme_classic()+
  labs(title="Multicampus")

pp=ggplot(data=mpg,aes(x=drv))

pp+geom_bar(fill="blue")+
  theme_bw()+
  labs(title="Multicampus",
       x='드라이브',
       y='빈도수'
       )+
  theme(plot.title=element_text(size=20,color='red',face="bold"),
        axis.title=element_text(size=15,color='purple',face="italic"))

#혼자서 해보기
#1
mpg=ggplot2::mpg
df_mpg=mpg %>% 
  filter(class=="suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

ggplot(data=df_mpg,aes(x=reorder(manufacturer,-mean_cty),y=mean_cty))+
  geom_col()

#2
ggplot(data=mpg,aes(x=class))+
  geom_bar()

library(forcats)
ggplot(data=mpg,aes(x=fct_infreq(class)))+
  geom_bar()

?forcats

colnames(economics)
ggplot(data=economics,aes(x=date,y=unemploy))+
  geom_line()



#부서별 인원수
gglot(data=df,aes(x=DEPARTMENT_NAME))+
  geom_bar()

#부서별 salary
ggplot(data=df,aes(x=DEPARTMENT_NAME,y=SALARY))+
  geom_point()

#부서별 salary의 평균
df %>% group_by(DEPARTMENT_NAME) %>% 
  summarise(mean_sal=mean(SALARY)) %>% 
  ggplot(aes(x=DEPARTMENT_NAME,y=mean_sal))+
  geom_col()

#혼자서 해보기
table(mpg$class)

mpg %>% filter(class %in% c("compact", "subcompact", "suv")) %>% 
  ggplot(aes(x=class,y=cty))+
  geom_boxplot()


#9.데이터 분석 프로젝트
install.packages("foreign")
library(foreign)             
library(dplyr)
library(ggplot2)
library(readxl)
df=read.spss(file="Data/Koweps_hpc10_2015_beta1.sav",
          to.data.frame = T)

class(df)
nrow(df)
colnames(df)
table(is.na(df))
head(df,1)
tail(df,1)

str(df)
summary(df)

df=rename(df,
       sex = h10_g3,            # 성별
       birth = h10_g4,          # 태어난 연도
       marriage = h10_g10,      # 혼인 상태
       religion = h10_g11,      # 종교
       income = p1002_8aq1,     # 월급
       code_job = h10_eco9,     # 직종 코드
       code_region = h10_reg7)  # 지역 코드
       )

colnames(df)
table(df$sex)
table(df$birth)
table(df$marriage)
table(df$religion)
table(df$income)
table(df$code_job)
table(df$code_region)
df
df$sex=ifelse(df$sex==1,"male","female")

table(df$sex)
qplot(df$sex)
summary(df$income)
table(is.na(df$income))
qplot(df$income)
                          

df[df$income==9999,"income"]

df=df %>% 
  mutate(income=ifelse(income %in% c(0,9999),NA,income))
df

#성별 월급 평균표 만들기
sex_income=df %>%  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income=mean(income))

ggplot(data=sex_income,aes(x=sex,y=mean_income))+
  geom_col()


class(df$birth)
summary(df$birth)
qplot(df$birth)

#이상치와 결측치가 없다.

table(is.na(df$birth)) #결측치 확인
st=boxplot(df$birth)$stats #이상치 확인

df %>% filter(birth<st[1]|birth>st[5])

df %>% mutate(age=2015-birth+1) %>% 
  select(age)

df$age<-2015-df$birth+1
summary(df$age)
qplot(df$age)

df<-df %>% 
  mutate(ageg=ifelse(age<30,"Young",ifelse(age<=59,"middle","old")))
table(df$ageg)
qplot(df$ageg)


