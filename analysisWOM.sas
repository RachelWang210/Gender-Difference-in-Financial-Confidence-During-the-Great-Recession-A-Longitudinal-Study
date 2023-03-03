proc import out=d1
 datafile='I:\project\7670\data.csv' 
 dbms=csv replace;
run;

/*creat Tcat*/
data d2;
 set d1;
if T=1 then Days=0;
if T=2 then Days=11;
if T=3 then Days=39;
if T=4 then Days=80;
if T=5 then Days=178;
if T=6 then Days=281;
if T=7 then Days=375;
if T=8 then Days=1050;
t1=t;
Days3=max(Days-39,0);
proc sort data=d2;
 by T;
run;

/*check normal before add missing*/
proc sgplot data =d2;
 histogram logC;
run;
/*test normal for VALUE*/
proc glm noprint data=d2;
 model logc=days g;
 output out =diag R=residual P=pred;
run; quit;
Proc univariate data=diag normal;
 var residual;
 qqplot residual/normal(l=1 mu=est sigma=est);
run; quit;
