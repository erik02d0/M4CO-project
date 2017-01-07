include "globals.mzn";

% example parameters:
int: n=9;		% number of workers
int: t=3;		% number of teams
int: d=3;		% number of drivers
int: ept = n div t;	% workers per team

% set up and constrain preference matrix
array[1..n,1..n] of var 0..8: P;
constraint forall(i in 1..n)(P[i,i] == 0);
constraint forall(i in 1..n)(alldifferent(col(P,i)) /\ alldifferent(row(P,i)));

% set up and constrain shift (the partition into teams):
array[1..n] of var 1..n: shift;
constraint alldifferent(shift);

% just playing around:
var int: satisf;
constraint satisf=sum([ P[shift[j],shift[k]] | j in 1..ept, k in 1..ept  ]);

solve satisfy; % for now
output[ show2d(P)++"\n"++show(shift)++"\n"++show(satisf) ];
