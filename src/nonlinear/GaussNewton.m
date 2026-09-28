%MÉTODO DE GAUSS-NEWTON

%El metodo de Gauss Newton funciona para cuando se tiene un sistema de
%ecuaciones en donda laguna de las ecuaciones no es lineal y se cuenta con
%MAS ecuaciones que variables (osea no es una matriz cudrada). Notese que
%es indipensable poner la ecuacion totalmente implicia he igulada a cero.


clear all; clc;
syms x y
x0=[1;1];
v=[x; y];
F=[exp(-x^2-3*y^2)-exp(-7/2);
    5*x^2+3*y^2-(19/12);
    x^2+x*y-y*2-(11/36)clcl];
J=jacobian(F,v);
max_iter=5;
tol=10e-5;
err=100;

i=1;
while(err>tol)
    F_ev=double(subs(F,v,x0));
    J_ev=double(subs(J,v,x0));
    x=x0-inv(J_ev'*J_ev)*J_ev'*F_ev;
    err=norm(x-x0);
    x0=x;
    fprintf('Iteración: #%d\n',i)
    fprintf('Valores de x0:%f\n',x0)
    fprintf('Error:%f\n',err)
    fprintf('\n')
    i=i+1;
end
% for i=1:max_iter
%     F_ev=double(subs(F,v,x0));
%     J_ev=double(subs(J,v,x0));
%     x=x0-inv(J_ev'*J_ev)*J_ev'*F_ev;
%     err=norm(x-x0);
%     x0=x;
%     fprintf('Iteración: #%d\n',i)
%     fprintf('Valores de x0:%f\n',x0)
%     fprintf('Error:%f\n',err)
%     fprintf('\n')
% end