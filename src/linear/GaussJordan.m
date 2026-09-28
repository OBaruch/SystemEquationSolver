clear all
clc
format long

A=[19,4,-4,3;-5,12,-5,-7;2,3,15,4;-1,-3,5,9]
[nr,nc]=size(A);
B=[82;19;48;14]
AB=[A,B];

if(det(A)!=0)
  for k=1:nr
    e=eye(nc);
    temp =-AB(:,k)/AB(k,k);
    temp(k)=1/AB(k,k);
    e(:,k)=temp;
    AB=e*AB
  endfor
endif
if(det(A)==0)
  disp ("Sin solucion...La determinante de la matriz es cero")
endif
