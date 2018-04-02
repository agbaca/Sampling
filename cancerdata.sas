/*proc import datafile="C:\Users\adamg_000\Desktop\BYAREA.csv" out=cancer;
run;
*/
data cancer;
infile "C:\Users\adamg_000\Desktop\BYAREA.csv" delimiter= ',' firstobs = 2;
input AREA $ AGE_ADJUSTED_CI_LOWER AGE_ADJUSTED_CI_UPPER AGE_ADJUSTED_RATE	COUNT EVENT_TYPE $ POPULATION RACE $ SEX $ SITE $ YEAR $ CRUDE_CI_LOWER CRUDE_CI_UPPER CRUDE_RATE;
sampwt = 3078/300;
/*mxy=313343.283*acres92;* mean estimate of y from
ratio estimation;*/
run;
/*data full;
set train.cancer(keep=AREA EVENT_TYPE SEX COUNT RACE SITE YEAR);
run;
*/
proc means data=cancer;
run;

proc stdize data=cancer
out=impute_train
method=median
reponly;
var AGE_ADJUSTED_RATE;
run;
proc means data=impute_train;
var AGE_ADJUSTED_RATE;
run;
data OHE(drop=SEX EVENT_TYPE AGE_ADJUSTED_CI_LOWER AGE_ADJUSTED_CI_UPPER);
set impute_train;
if sex in ('MALE') then do;
MALE=1;
end;

if SEX in ('FEMALE') then do;
MALE=0;
end;

if EVENT_TYPE in ('Incidence') then do;
SURVIVED=1;
end;

if EVENT_TYPE in ('Mortality') then do;
SURVIVED=0;
end;

label SURVIVED='SURVIVED=1,MORTALITY=0';
label MALE='MALE=1,FEMALE=0';

run;
proc means data=OHE n nmiss;
run;
