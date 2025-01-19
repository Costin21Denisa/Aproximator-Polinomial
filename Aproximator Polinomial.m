close all
clear all
clc

%proiect
load('proj_fit_17.mat');

yid= id.Y;     
xid1= id.X{1};  
xid2= id.X{2};  

subplot(211)
mesh(xid1, xid2, yid)
title("Date de Identificare");
xlabel('X1');
ylabel('X2');
zlabel('Y');

yval= val.Y;     
xval1= val.X{1};  
xval2= val.X{2}; 


m=11; 

f= factorial(m+2)/(factorial(m)*factorial(m+2-m));
c=int32(f);
phi= ones(length(xid1)*length(xid2), c);

philinie=1;
for i=1:length(xid1)
    for j=1:length(xid2)
        phicoloana=1;
        for p1=0:m
            for p2=0:m
                if p1+p2<=m
                     phi(philinie, phicoloana)= xid1(i).^p1*xid2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end
disp(phi)
yid= reshape(yid,1, length(xid1)*length(xid2));
thetaid= phi\yid';

yprimid= phi*thetaid;
yprimid= reshape(yprimid,length(xid1),length(xid2));

subplot(212)
mesh(xid1, xid2, yprimid)
title("Functie aproximata dupa datele de identificare");
xlabel('X1');
ylabel('X2');
zlabel('Y');

figure
subplot(211)
mesh(xval1, xval2, yval)
title("Date de Validare");
xlabel('X1');
ylabel('X2');
zlabel('Y');

phival= ones(length(xval1)*length(xval2), c);

philinie=1;
for i=1:length(xval1)
    for j=1:length(xval2)
        phicoloana=1;
        for p1=0:m
            for p2=0:m
                if p1+p2<=m
                     phival(philinie, phicoloana)= xval1(i).^p1*xval2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end

yval=reshape(yval, 1, length(xval1)*length(xval2));
thetaval= phival\yval';

yprimval= phival*thetaval;
yprimval= reshape(yprimval, length(xval1), length(xval2));

subplot(212)
mesh(xval1, xval2, yprimval)
title("Functie aproximata dupa datele de validare");
xlabel('X1');
ylabel('X2');
zlabel('Y');


%%
m= 11;

MSEid= zeros(1, m);
MSEval= zeros(1, m);

for l=1:m
    f = factorial(l+2) / (factorial(l) * factorial(l+2 - l));
    c=int32(f);
    %c=(l+1)*(l+2)/2;
    phi= ones(length(xid1)*length(xid2), c);

philinie=1;
for i=1:length(xid1)
    for j=1:length(xid2)
        phicoloana=1;
        for p1=0:l
            for p2=0:l
                if p1+p2<=l
                     phi(philinie, phicoloana)= xid1(i).^p1*xid2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end

yid= reshape(yid, 1, length(xid1)*length(xid2));
thetaid= phi\yid';

yprimid= phi*thetaid;
%yprimid= reshape(yprimid, length(xid1), length(xid2));

phival= ones(length(xval1)*length(xval2), c);

philinie=1;
for i=1:length(xval1)
    for j=1:length(xval2)
        phicoloana=1;
        for p1=0:l
            for p2=0:l
                if p1+p2<=l
                     phival(philinie, phicoloana)= xval1(i).^p1*xval2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end
yval= reshape(yval, 1, length(xval1)*length(xval2));
thetaval= phival\yval';

yprimval= phival*thetaval;
%yprimval= reshape(yprimval, length(xval1), length(xval2));

eror= yid-yprimid';
sumerori=0;
for i=1:length(xid1)*length(xid2)
    sumerori= sumerori+eror(i).^2;
end
MSEid(l)=(1/(length(xid1)*length(xid2)))*sumerori


eror1= yval-yprimval';
sumerori1=0;
for i=1:length(xval1)*length(xval2)
    sumerori1= sumerori1+eror1(i).^2;
end
MSEval(l)=(1/(length(xval1)*length(xval2)))*sumerori1;
end

figure;
plot(MSEid);
grid on;
hold on;
plot(MSEval);

[MinMseVal, MseVal]=min(MSEval);
plot(MseVal, MinMseVal,'r*');
title("Grafic MSE");
legend('MseVal', 'Mseid', 'Valoarea optima');
ylabel('Valoarea MSE');
xlabel('Gradul polinomului');