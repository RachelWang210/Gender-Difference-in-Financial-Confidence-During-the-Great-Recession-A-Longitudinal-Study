proc import out=d1
 datafile='I:\project\7670\missed.csv' 
 dbms=csv replace;
run;

/*create ID*/
data d2;
 set d1;
 ID=_n_;
run;

/*transpose*/
proc transpose data=d2 (rename=(logC1-logC8=time1-time8))   
               out=tall_d (rename=(col1=logC)) name=Time;
  by ID gender;
  var time1-time8;
  attrib _all_ label=' ';
run;

/*transform*/
data d3;
 set tall_d;
 *logC=log(confidence+1/(100-confidence+1));
 T1=substr(Time,5,1);
 T=input(T1,8.);
run;


data d3;
 set d3;
 if gender='(1) Male' then G=1; else G=0;
 label G='Gender';
 keep ID G Confidence logC T;
run;

/*export the data*/
proc export data=d3 
dbms=csv outfile="I:\project\7670\miss.csv" replace;
run;
