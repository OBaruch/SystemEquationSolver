%MÉTODO DE NEWTON RAPHSON BIVARIADO

%El metotod de newton rapson sirve en los casos que se cuenta con algun
%sistema de ecauciones no lienal osea que cualquiera de las acuaciones no sea lienal
%y que se tenga el mismo numero de ecuaciones que de variables, en el caso
%de contar con mas ecuaciones que variables ir al metodo de "GaussNewton".
%es decir es una matriz cuadrada. Notose que las ecaucioes tiene que ir
%escritas de froma implicita y tiene que estar igualdas a cero.

clear all; clc;
syms x y
x0=[1; 1];
v=[x; y];
F=[exp(x^2+3*y)-3; x^2-y];
J=jacobian(F,v);
max_iter=5;
tol=10e-4;
err=100;

i=1;
% while(err>tol)
%     F_ev=double(subs(F,v,x0));
%     J_ev=double(subs(J,v,x0));
%     x=x0-inv(J_ev)*F_ev;
      
%     err=norm(x-x0);
%     x0=x;
%     fprintf('Iteración: #%d\n',i)
%     fprintf('Valores de x0:%f\n',x0)
%     fprintf('Error:%f\n',err)
%     fprintf('\n')
%     i=i+1;
% end
for i=1:max_iter
    F_ev=double(subs(F,v,x0));
    J_ev=double(subs(J,v,x0));
    x=x0-inv(J_ev)*F_ev;
    err=norm(x-x0);
    x0=x;
    fprintf('Iteración: #%d\n',i)
    fprintf('Valores de x0:%f\n',x0)
    fprintf('Error:%f\n',err)
    fprintf('\n')
end