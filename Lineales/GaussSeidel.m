%Gauss Seidel
clear all
clc
format long

A=[4,-3,-5,11,-6;0,6,-5,6,11;7,-7,-6,1,2;-1,10,-8,-3,6;-6,-8,11,4,5]
[nr,nc]=size(A);
B=[9;65;-20;43;-19]
tol=10e-5

if(det(A)!=0)
D=triu(A)+tril(A)-A;
L=tril(A);
U=triu(A)-D;
x0=A\B; %DEFINIDO Valores reales de x
errAbs=10e10;
s=[];

    if(tol>=1)
        for k=1:tol
            x1=inv(D)*(B-U*x0);
            errAbs=norm(x0-x1);
            errRel=errAbs/norm(x1);
            x0=x1;
            s=[s;[x1',errAbs]];
            endfor
    
    
    else
        while (errAbs>=tol)
            x1=inv(D)*(B-U*x0);
            errAbs=norm(x0-x1);
            errRel=errAbs/norm(x1);
            x0=x1;
            s=[s;[x1',errAbs]];
            endwhile
    endif
s
endif


if(det(A)==0)
disp ("Sin solucion...La determinante de la matriz es cero")
endif





