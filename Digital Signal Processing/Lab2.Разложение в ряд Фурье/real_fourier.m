% Разложение функции t в ряд Фурье
%в дискретизированном виде на интервале [-T,T], например,[-pi,pi]

clc;
N = 8192; %Количество отсчетов (элементов массива y(t))
K = 2048;%Количество членов ряда Фурье
T=pi;
%T=5;
T=0.9*pi; %диапазон изменения функции f(i) равен +/-T
kp=1.1; %количество периодов гармонической функции
y=zeros(1,N+1);
Sa = zeros(1,K);
Sb = zeros(1,K);
p=1;% показатель степени функции t^p
f=zeros(1,N+1);
Sa0=0;
%for i=1:N+1
for i=2:N    
% f(i)=sin(2*pi*kp*(i-1)/N); % гармоническая функция
x(i)=(2*T*(((i-1-N/2))/N));
%f(i)=sign(sin(2*pi*kp*(i-1)/N));
% f(i)=x(i)*cos(x(i));
%f(i)=(-tan(x(i)/2))/2;
% f(i)=log(2+cos(x(i)/2));%вариант 10
%f(i)=log(2+cos(x(i)/2));%вариант 10
% f(i)=log(1+x(i)^p);
% f(i)= (2*T*(((i-1-N/2))/N))^p; %функция t^p
% f(i)=x(i)^3-1;
% f(i)=x(i)^p;
% f(i) s(x(i));
% f(i)=sinh(x(i));
% f(i)=sin(x(i));
%f(i)=cosh(x(i)); %Вариант 14 - f(x)=ch(x)
% f(i)=x(i)*exp(x(i));
%f(i)=exp(x(i));
%f(i)=x(i)*sin(x(i));

Sa0=Sa0+f(i);
end
Sa0=Sa0/N; %вычисленный коэф. a0/2
%Saa0=pi^2/3 %%теоретически определенные коэф. а0/2 для функции t^2
figure
i=1:N;
plot(i,f(i));
title('f(i)');
axis tight;
for i=1:N+1
for j=1:K
Sa(j) = (Sa(j)+f(i)*cos((j)*2*T*(i-1-N/2)/N));%**********
Sb(j) = (Sb(j)+f(i)*sin((j)*2*T*(i-1-N/2)/N)); %**********
end

end
for j=1:K
Sa(j)=Sa(j)*(1/(N/2));
Sb(j)=Sb(j)*(1/(N/2));
% Saa(j)= 4*(-1)^j/(j^2);%теоретически определенный коэф. аk для функции t^2
end
SSa=Sa; %коэффициенты ak
SSb=Sb %коэффициенты bk
%SSaa=Saa %теоретически определенные коэф. аk для функции t^2
% i=1:K;
% figure
% plot(i,Sa);
% title('Коэффициенты Sa');
%Вычисление и отображение спектра амплитуд (начало)
for j=1:K
Sab(j)=sqrt(Sa(j)^2+Sb(j)^2);
end
K1=K;
i=1:K1;
figure
plot(i,Sab(i));
stem(Sab(1:K1)); %вывод графика дискретной последовательности данных
axis([1 8 -0.2 1.2]);%задание осей: [xmin xmax ymin ymax]
title('Амплитуды частотных составляющих спектра');
xlabel('Количество периодов')
axis tight;
%Вычисление и отображение спектра амплитуд (конец)
y=zeros(1,N+1);
for i=1:N+1
for j=1:K
y(i)= y(i)+Sa(j)*cos(j*2*T*(i-1-N/2)/N)+Sb(j)*sin(j*2*T*(i-1-N/2)/N); %%%%%%%%
end
y(i)=(Sa0+y(i));
end
i=1:N+1;
figure
plot(i,f);
axis tight;
hold on;
plot(i,y,'r-')
hold off;

for i=2:N
dy(i)=y(i)-f(i);%абсолютная погрешность восстановления
end
dy_proc=dy/(max(f)-min(f))*100;
CKO=std(dy);
CKO_proc=std(dy_proc)%СКО в процентах

pause;
close all;
clear;