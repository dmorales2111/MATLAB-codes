function z = SECT(Dattemp,lo,hi)
% SECT subroutine that creates a subset array as defined
% by the Dattemp limits lo and hi (lo is the lower limit).
% format: SECT(x,lo,hi) where Dattemp is a 2 column matrix array.  
% Output is a subset 2 column matrix array.

% establish standard order
if Dattemp(1,1) > Dattemp(2,1)
	Dattempx=MIRROR(Dattemp(:,1))';
    Dattempy=MIRROR(Dattemp(:,2))';
    Dattemp=[Dattempx,Dattempy];
end

len=length(Dattemp(:,1));
for j=1:len
	if Dattemp(1,1) >= lo
		ilow=1;
    elseif Dattemp(j,1) < lo %finds the index of lower limit
		ilow=j+1;
	end
	if Dattemp(len,1) <= hi
		ihi=len;
    elseif Dattemp(j,1) < hi %finds the index of upper limit
		ihi=j;
	end
end

z = Dattemp(ilow:ihi,:);
end %SECT
