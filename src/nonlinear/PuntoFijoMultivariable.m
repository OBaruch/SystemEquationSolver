%MÉTODO DE PUNTO FIJO BIVARIADO
clear all; clc;
syms x y
x0=[0.525; 0.275];
v=[x; y];
F=[exp(x^2+3*y)-3; x^2-y];
F_desp=[(log(3) - 3*y)^(1/2); x^2];
J=jacobian(F,v);
J_ev=double(subs(J,v,x0));
max_iter=5;
tol=10e-4;
err=100;
i=1;
% while(err>tol)
%     x=double(subs(F_desp,v,x0));
%     err=norm(x-x0);
%     x0=x;
%     fprintf('Iteración: #%d\n',i)
%     fprintf('Valores de x0:%f\n',x0)
%     fprintf('Error:%f\n',err)
%     fprintf('\n')
%     i=i+1;
% end
for i=1:max_iter
    x=double(subs(F_desp,v,x0));
    err=norm(x-x0);
    x0=x;
    fprintf('Iteración: #%d\n',i)
    fprintf('Valores de x0:%f\n',x0)
    fprintf('Error:%f\n',err)
    fprintf('\n')
end