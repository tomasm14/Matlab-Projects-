%Mech-103 Final Project
%Tomas Martinez 
%Group #1

clear;
clc;

%Conversions
cnvtlbs_N=4.44822;
cnvtin_m=0.0254;

%Experimental Data
SSstiffness=xlsread('slingshotstiffness');
SSdata=xlsread('slingshotdata');

%Calculated 'k' stffness
F_=SSstiffness(:,1)*cnvtlbs_N;
m_=SSstiffness(:,2)*cnvtin_m;
k = polyfit(m_,F_,1);
k_est = k(1);
fprintf('The stiffness of the slingshot is %0.2fN/m\n',k_est)

%Calcutalted launch with cetrain angle and launch force 
% F=input('Enter Force for pulling back slingshot(in Newtons):');
% Theta_=input('Enter angle of launch(in degrees):');
F=SSdata(:,5)*cnvtlbs_N;
Theta_=SSdata(:,2)*0.0174533;
y_o=33*0.0254;
MP=.2;

for i=1:3
    y=y_o;
    t=0;
    Fp=F(i,1);
    Theta=Theta_(i,1);
    x=Fp/k_est;
    vtot=sqrt((k_est*(x^2))/MP);
    v_y=vtot*sin(Theta);
    v_x=vtot*cos(Theta);
    while y>0
        t=t+.0001;
        y=y_o+(v_y*t)+.5*(-9.81*(t^2));
    end
    dist_x1(i)=(v_x*t);
    fprintf('For calculated launch number %0.0f:\n Angle=%0.2fradians\n Force=%0.2fN\n Time=%0.2fs\n Distance=%0.2fm\n',i,Theta,Fp,t, dist_x1(i) );
end

%Expirimental launch results
Theta1=SSdata(:,2)*0.0174533;
dist_x=SSdata(:,3)*0.3048;
for i=1:3
    A=Theta1(i,1);
    B=F(i,1);
    C(i)=dist_x(i,1);
    fprintf('For experimental launch number %0.0f:\n Angle=%0.2fradians\n Force=%0.2fN\n Distance=%0.2fm\n', i, A, B, C(i));
end

for i=1:3
    error=abs((C(i)-dist_x1(i))/dist_x1(i))*100;
    dif=abs(C(i)-dist_x1(i));
    pctdif=(dist_x1(i)/C(i))*100;
    fprintf('For launch %0.0f:\n Measured difference=%0.2fmeters\n Percent difference=%0.2fpercent\n Percent error=%0.2fpercent\n',i,dif,pctdif,error)
end






