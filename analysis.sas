proc import out=d1
 datafile='I:\project\7670\miss.csv' 
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
Days3=max(Days-39,0);
proc sort data=d2;
 by T;
run;

/*get the mean of the group*/
proc sort data=d2;
 by gender descending Days;
run;

proc means noprint data=d2 n mean std stderr;
 var logc;
 by gender descending Days;
 output out=meand1 mean=mean std=sd;
run;

/*plot*/ 
ods listing gpath = 'I:\project\7670';
symbol1 value = circle interpol = join;
symbol2 value = star interpol = join;
proc gplot data = meand1;
   plot mean*Days=gender;
run; quit;

/*check normal after add missing*/
proc sgplot data =d2;
 histogram logC;
run;
/*test normal for VALUE*/
proc glm noprint data=d2;
 model logc=days gender;
 output out =diag R=residual P=pred;
run; quit;
Proc univariate data=diag normal;
 var residual;
 qqplot residual/normal(l=1 mu=est sigma=est);
run; quit;

/*regular regression*/
proc mixed data=d2;
 class id T1 gender;
 model logc= Days gender gender*Days  /s chisq;
 repeated T1/type=un subject=id r rcorr;
run; quit;

/*reg reg with knot day3*/
proc mixed data=d2;
 class id T1 gender;
 model logc= Days gender gender*Days Days3 gender*Days3 /s chisq;
 repeated T1/type=un subject=id r rcorr;
run; quit;

/*profile (time conti)*/
proc mixed data=d2;
 class id Tcat g;
 model logc= Days g g*Days Days3 g*Days3 /s chisq;
 repeated Tcat/type=un subject=id r rcorr;
run; quit;

ods trace on;
ods trace off;
/*Hetero top*
proc mixed data=d2;
 class id Tcat g;
 model logc= Days g g*Days Days3 g*Days3 /s chisq;
 repeated Tcat/type=toeph subject=id r rcorr;
 ods select SolutionF Tests3 FitStatistics;
run; quit;*/

/*Hetero Ex*/
proc mixed data=d2;
 class id T1 gender;
 model logc= Days gender gender*Days Days3 gender*Days3 /s chisq;
 repeated T1/type=sp(exp)(Days) subject=id r rcorr;
 ods select SolutionF Tests3 FitStatistics;
run; quit;

/*hetero AR(1)*
proc mixed data=d2;
 class id Tcat g;
 model logc= Days g g*Days Days3 g*Days3 /s chisq;
 repeated Tcat/type=ARH(1) subject=id r rcorr;
 ods select SolutionF Tests3 FitStatistics;
run; quit;


/*p-value*/
data P; 
 p_t=1-probchi(71.1,21);
 p_e=1-probchi(174.5,27);
 p_a=1-probchi(266.1,34);
 run;
proc print data=p;
run;

/*random int&t&time3*/
proc mixed data=d2;
 class id T1 gender;
 model logc= days gender gender*days/s chisq;
 random intercept days/type=un subject=id g gcorr v vcorr;
run; quit;


/*profile (time cat)
proc mixed data=d2;
 class id Tcat g;
 model logc= Tcat| g/s chisq;
 repeated Tcat/type=un subject=id r rcorr;
run; quit;


/*mix model int
proc mixed data=d2;
 class id Tcat g;
 model logc = t g g*t/s chisq;
 random intercept /type=un subject=id g v;
run;quit; 

/*random t
proc mixed data=d2;
 class id Tcat g;
 model logc=t g g*t/s chisq;
 random t/type=un subject=id g v;
run; quit;


/*random int & t*
proc mixed data=d2;
 class id Tcat g;
 model logc = t g g*t/s chisq;
 random intercept t /type=un subject=id g v;
run;quit; 


