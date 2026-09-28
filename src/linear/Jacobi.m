%%A=randi(10,3,3)
%10 el rango
%3cfila
%3 columna
%A=randi(10,4,4)%Matriz Sistema

%triu(A)%Triangulo Inferior 
%tril(A)%Triangulo Superior
%inv(A)%Inversa
%det(A) %Determinate 
%A' %TRanspuesta
clear all
clc
format long
Metodo de Jacobi
A=[4,-3,-5,11,-6;0,6,-5,6,11;7,-7,-6,1,2;-1,10,-8,-3,6;-6,-8,11,4,5]
[nr,nc]=size(A);
B=[9;65;-20;43;-19]

tol=10e-5

if(det(A)!=0)#Verifica que la deterinante de la matriz sea difernete de cero
    
    
    errAbs=10e10;
    D=triu(A)+tril(A)-A;
    R=A-D;
    x0=[0;0;0;0;0];#Valores de inicio
    #x0=A\B;
    s=[];
    if(tol>=1)
        for k=1:tol
          x1=inv(D)*(B-R*x0);#METODO
          errAbs=norm(x0-x1);
         errRel=errAbs/norm(x1);
         x0=x1; s=[s;[x1' errAbs]];
        endfor
    else
        while (errAbs>tol)
            x1=inv(D)*(B-R*x0);
             errAbs=norm(x0-x1);
             errRel=errAbs/norm(x1);
             x0=x1; s=[s;[x1' errAbs]];
         endwhile
    endif
s
endif





if(det(A)==0)
disp ("Sin solucion...La determinante de la matriz es cero")
endif





