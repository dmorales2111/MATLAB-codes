function [a,b] = compositionInGaAs(lc)
%returns the composition of In and Ga in grown InGaAs for measured lattice
%constant of InGaAs

a = (lc-5.6533)/(6.0583-5.6533);
b = 1-a;
