% p11.m - Chebyshev differentation of a smooth function

  xx = -1:.01:1; uu = cosh(xx).*cos(xx); clf
  for N = [10 20]
    [D,x] = cheb(N); u = cosh(x).*cos(x);
      subplot('position',[.15 .66-.4*(N==20) .31 .28])
      plot(x,u,'.','markersize',14), grid on
      line(xx,uu)
      title(['u(x),  N=' int2str(N)])
    error = D*u - cosh(x).*cos(x);
      subplot('position',[.55 .66-.4*(N==20) .31 .28])
      plot(x,error,'.','markersize',14), grid on
      line(x,error)
      title(['error in u''(x),  N=' int2str(N)])
  end

  
function [D,x] = cheb(N)
% CHEB  Trefethen's Chebyshev spectral collocation scheme over [-1,1].
%
% [D,x] = cheb(N)
%
%  x - Chebyshev collocation points in descending order
%      [column-vector of length N+1]
%
% D - differentiation matrix
%      [square matrix, size N+1]
%
% See also MYCHEB, LEG, PCHEB.

if N==0, D=0; x=1; return, end

x = cos(pi*(0:N)/N)';
c = [2 ones(1,N-1) 2] .* ((-1).^(0:N));  % c = [2 -1 1 -1 ... 1 -1 2]
X = repmat(x,1,N+1);
D_numer = c' * (1./c);
D_denom = (X - X') + eye(N+1);
D = D_numer./D_denom;
D = D - diag(sum(D'));  
end