#working directory setting
setwd("C:/dev_R")

#현재working directory get
getwd()
a=10
b=20
c=a+b
c

a=10;b=20
c=a+b;c
a/b; 
a%%#몫
a%%b #나머지

#할당
a=100
a<-200
300->a

a==b
a!=b
!a

a=FALSE
b=10
#&는 무조건 양쪽모두수행
a&(b<-b+1)>20; b
#&&는 앞쪽이 false이면 뒤쪽을 수행x
b=10
a&&(b<-b+1)>20; b
#or는 하나라도 참이면 참이다.
#앞에것이 참이면 뒤쪽을 수행할 것인가?
b=10
TRUE| (b<-b+1)>20; b #한다
b=10
TRUE|| (b<-b+1)>20; b #안한다

#data유형
a = 10
b = "알까기"
c= FALSE
d= 1+2i
#NaN:수학적으로 계산이 불가능한 수
e=NaN
f=NULL
#NA:Not Available
g=NA
a;b;c;d;e;f;g;

#문자형 형태로 데이터 타입을 보여준다
mode(a);mode(b);mode(c);mode(d)

#is=Ture or false로 결과값
#is.numeric(수치형여부)
is.numeric(a);is.numeric(b)

#is.na(na여부),isnull(null여부)
is.na(g);is.null(f)

#벡터를 만들때 여러가지 유형을 넣어도 우선순위에 따라 하나의 유형으로 변경
a=c(1,"2",3,4,TRUE);a

#as.numeric(수치형으로 형변환)
a=as.numeric("100")
is.numeric(a)

a=as.numeric("AAA")
is.numeric(a) --type의 numeric
is.numeric(NA)
mode(a)
is.na(a)
a

#벡터
#c()함수는 combine의 약자
#벡터를 생성하는 가장 대표적 방법
#규칙없는 데이터로 이루어진 벡터를 생성
var1=c(10,2,30,44,5)
var2=c("apple","banana","orange")
var3=c(TRUE,FALSE,TRUE,FALSE)
var4=c(10,"green",TRUE,3.14,1+2i)
var5=c(var1,var2,var3,var4)
var5 #우선순위는 문자가 가장 높다.

#콜론
#var1=start:end, 1씩 증가
#수치형에만 적용
var1=1:5; var1
var2=5:1;var2
var4=-3:3; var4

#seq():sequence
#1이외의 증가/감소 벡터를 만들 수 있음
#수치형에만 적용
var1=seq(1,10,3); var1
var1=seq(from=1,to=10,by=3);var1

#sequence(숫자)
var2=sequence(10); var2 #1~10까지 정수

#1~3을 표현하는 여러가지 방법
c(1,2,3)
seq(1,3,1)
sequence(3)

#rep:replicate의 약자
#다양한 형으로 된 벡터를 생성 가능

#times에 지정된 만큼 전체 벡터를 복사
rep(c("a","b"),times=3)
#each에 지정된 숫자 만큼 각각 복사
rep(c("a","b"),each=3)


var1=c(10,20,"30",40,50)
mode(var1)
is.character(var1)
var1
#몇개의 원소를 가지고 있는지
length(var1)

names(var1) #null,부여된 이름이 없기 때문에

#이름부여(인덱싱)
names(var1)=c("A","B","C","D","E")
names(var1)
var1
var1[3]
var1[3:5]
var1[c(1,5)]
var1[seq(3)] #seq(3)=>1,2,3

#벡터의 연산
v1=1:3 #1,2,3
v2=4:6 #4,5,6
v1+v2

#벡터의 길이가 동일하지 않은 경우 연산
v1=c(1,2,3,8,9)
v1
v2=4:6
v1+v2

#factor의 데이터 중에서 하나이며 벡터의 한 종류-한정적목록
#범주형:(집단별로 자료를 분석하고자 할 때)
#1)명목형:성별,국적..순서없음 
#2)순서형:소득순위,학점..순서있음
gender=c("M","F","F","M","M","M") #문자로 넣음
gender=factor(gender) #factor로 바꿔주기


#명목형
#levels:있을수있는 값, 그룹으로 지정할 문자형 벡터를 지정
#labels:levels에 대한 문자형 벡터를 지정
gender2=factor(gender,levels=c("M","F"),labels=c("남","여"),ordered=FALSE)

#순서형
size=c("대","소","대","중","중","대")
fsize=factor(size,levels=c("소","중","대"),labels=c("소","중","대"),ordered=TRUE)
gender3=factor(gender,levels=c("M","F"),labels=c("남","여"),ordered=TRUE)

sort(gender2)
sort(gender3)
sort(fsize)
is.ordered(fsize)
is.ordered(gender2)

mode(gender)
typeof(gender)
is.character(gender)
is.factor(gender)
levels(gender)
levels(gender2) #집단의 이름
levels(gender3)

#행렬
v1=1:5
v2=6:10
#행 방향으로 합치는 방법
v3=rbind(v1,v2);v3
#열 방향으로 합치는 방법
v4=cbind(v1,v2);v4

#칼럼을 먼저 채운다...col방향
v5=matrix(1:10,nrow=5,ncol=2);v5
#row를 먼저 채운다...row방향(byrow)
v6=matrix(1:10,nrow=5,ncol=2,byrow=TRUE);v6


#1차원
var1=array(1:10,dim=10);var1
#dim:원하는 차원

#2차원(2행5열)
var2=array(1:10,dim=c(2,5));var2
#3차원(2행3열4개)
var3=array(1:10,dim=c(2,3,4));var3

#vector
v1=1:5
#array
v2=array(1:6,dim=c(2,3))
#matrix
v22=matrix(1:6,nrow=2,ncol=3)
#factor
v3=factor(c('m','f','m'))
#list
v4=list(v1,v2,v22,v3);v4

#typeof:type 알아보기
typeof(v4[4])
typeof(v4[[4]])
#4번째 꺼 가져오기
v4[[4]][1]
v4[[3]][2,3]

aa=matrix(1:6,nrow=2,ncol=3);aa
aa[2,2]

x=c(1,2,3,4,5)
result=list(mul=x*2,div=x/2,root=sqrt(x))
result
result$div

a=10
a<-'aaa';a
a<-"aaa";a
a+2 #불가
#time(횟수)
rep(a,times=2)

x=c(1,2,3,4,5)
mean(x)
max(x)
min(x)

a=c("Hello","R","Python")
a[0]+","+a[1]+","+a[2] #불가

paste(a,collapse=" ")
paste0(a,collapse = " ")

#package
#PL/SQL:procedure+function들
#R:function+data들

x=c("a","a","a","b","b","c")
install.packages("ggplot2")
library(ggplot2)

#도수분포
qplot(x)

data("iris")
typeof(iris)

typeof(mpg)
str(mpg)
mpg$hwy
data=mpg

#hwy:고속도로연비
qplot(data=mpg,x=hwy)
#cty:도시연비
qplot(data=mpg,x=cty)
#drv:자동차 구동방식
qplot(data=mpg,x=drv,y=cty,geom="line")

qplot(data = mpg, x = drv, y = hwy, geom = "boxplot")

qplot(data = mpg, x = drv, y = hwy, geom = "boxplot", colour = drv)
#4,f,r
mpg$drv

?qplot

#1
score<-c(80,60,70,50,90)
score

#2,3
average<-mean(score)
average

# #ctrl+shift+c -->전체주석처리 단축키



