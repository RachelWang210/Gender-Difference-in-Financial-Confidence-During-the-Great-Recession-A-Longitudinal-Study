proc import out=d1
 datafile='I:\project\7670\miss\stat_7670_data(1).xlsx' 
 dbms=xlsx replace;
 sheet=	'sheet3';
run;

/*transoframation*/
data d2;
 set d1;
 logC1=log(confidence1+1/(100-confidence1+1));
 logC2=log(confidence2+1/(100-confidence2+1));
 logC3=log(confidence3+1/(100-confidence3+1));
 logC4=log(confidence4+1/(100-confidence4+1));
 logC5=log(confidence5+1/(100-confidence5+1));
 logC6=log(confidence6+1/(100-confidence6+1));
 logC7=log(confidence7+1/(100-confidence7+1));
 logC8=log(confidence8+1/(100-confidence8+1));
run;



/*missing MI*/
proc mi data=d2 seed=346895 nimpute=25 out=d3;
 var gender logC1 logC2 logC3 logC4 logC5 logC6 logC7 logC8;
 mcmc nbiter=5000 niter=500;
run;

proc export data=d3 
dbms=csv outfile="I:\project\7670\missed.csv" replace;
run;
