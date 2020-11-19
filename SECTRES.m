function z = SECTRES(M,xmin,xmax,n)
%SECTRES(M, xmin, xmax, n) subroutine for creating an n row x 2 col (n x-y pairs) array with a regular X basis (1st column), 
%between xmin and xmax, interpolated from the M (Y-values, 2nd column).  
%M is a 2-column (x,y) array.  Nice way to pad (with zeros); take xmin and
%xmax beyond the natural limits of M.

if n<=1 
    n=2;
end 
n = n+4; %to compensate for erroneous 1st and last data pts, that will be deleted

%preallocate memory
x=zeros(n,1);
y=zeros(n,1);

Mtemp = SECT(M,xmin,xmax);

delx=(xmax-xmin)/(n-1); %create regularly spaced x array
for i=1:n
    x(i)=xmin+(i-1)*delx;
end

%interpolate data points
%for k=1:length(M)
for k=1:n
 %   if x(k)>=Mtemp(1,1) && x(k)<=Mtemp(length(Mtemp),1) %check for x in range
        for l=1:length(Mtemp)-1
            if x(k) >= Mtemp(l,1) && x(k) <= Mtemp(l+1,1)	
                slope = (Mtemp(l+1,2)-Mtemp(l,2))/(Mtemp(l+1,1)-Mtemp(l,1));
                Inter = Mtemp(l+1,2)-slope*Mtemp(l+1,1);	
                y(k) = x(k)*slope+Inter;
            end
        end
  %  end
end

x=x(3:n-2); %get rid of erroneous beginning and end pts.
y=y(3:n-2); %get rid of erroneous beginning and end pts.
%y=y/max(y); Normalize
%z = Mtemp;
z = [x,y];
end