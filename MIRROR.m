function z = MIRROR(y)

%MIRROR subroutine for reversing the order of discrete data
%format is MIRROR(y), where y is a 1-d vector array.
%tstart = tic; %start timer (timer ends at END of program)
m=y; %allocate memory
for j=1:length(y)
	m(j)=y(length(y)-j+1);
end
%toc(tstart) %end timer
z=m'; %creates a row array (not a column)
