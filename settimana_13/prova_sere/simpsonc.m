function [Isic]=simpsonc(a,b,M,f,varargin)
%SIMPSONC Formula composita di Simpson
%   ISIC = SIMPSONC(A,B,M,FUN) calcola una
%   approssimazione dell'integrale della funzione
%   FUN tramite la formula composita di Simpson
%   (su M intervalli equispaziati). FUN e' una
%   function che riceve in ingresso un vettore reale x
%   e restituisce un vettore reale.
%   FUN puo' essere una inline function.
%   ISIC = SIMPSONC(A,B,M,FUN,P1,P2,...) passa alla
%   function FUN i parametri opzionali P1,P2,...
%   come FUN(X,P1,P2,...).
H=(b-a)/M;
x=linspace(a,b,M+1);
fpm=feval(f,x,varargin{:}).*ones(1,M+1);
fpm(2:end-1) = 2*fpm(2:end-1);
Isic=H*sum(fpm)/6;
x=linspace(a+H/2,b-H/2,M);
fpm=feval(f,x,varargin{:}).*ones(1,M);
Isic = Isic+2*H*sum(fpm)/3;
return
