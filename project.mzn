include "globals.mzn";

% Example parameters and initial checks:
int: n=9;		% number of workers
int: t=3;		% number of teams
int: d=3;		% number of drivers
constraint assert(n mod t == 0, "...");
constraint assert(d >= t, "Not enough drivers (d).");
int: wpt = n div t;	% workers per team

% Set up and constrain preference matrix:
array[1..n,1..n] of var 0..n-1: P;
constraint forall(i in 1..n)(P[i,i] == 0);
constraint forall(i in 1..n)(alldifferent(col(P,i)) /\ alldifferent(row(P,i)));

% Set up and constrain shift (the partition into teams):
array[1..n] of var 1..n: shift;
constraint alldifferent(shift);

% The drivers are numbered 1..d. Choose driver for each team:
array[1..t] of var 1..d: teamDrivers;
constraint alldifferent(teamDrivers);
% Symmetry-breaking?:
constraint forall(i in 2..t)(teamDrivers[i-1] < teamDrivers[i]);

% Each team must have a driver:
constraint forall(i in 1..t)(shift[wpt*(i-1)+1]=teamDrivers[i]);

% Satisfaction/dissatisfaction calculated here:
array[1..t] of var int: satisf;
constraint forall(i in 1..t)(satisf[i] = sum([ P[shift[wpt*(i-1)+j], shift[wpt*(i-1)+k]] | j in 1..wpt, k in 1..wpt ]));

% Objective:
solve minimize satisf[1];
output[ show2d(P)++"\n"++show(shift)++"\n"++show(satisf) ];
