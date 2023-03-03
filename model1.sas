/*profile (time conti)*/
proc mixed data=d2;
 class id Tcat g;
 model logc= t g g*t time3 g*time3 /s chisq;
 repeated Tcat/type=un subject=id r rcorr;
run; quit;
