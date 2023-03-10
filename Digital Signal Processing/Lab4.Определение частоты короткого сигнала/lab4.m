%Комбинированное использование ключевых операций ЦОС
%Для повышения точности определения частоты
%"короткого" сигнала используется комбинация
%БПФ, кросскорреляции, сплайн-аппроксимации,передискретизации
%В качестве показателя сравнения исходного и эталонных сигналов
%предусмотрена возможность использования коэффициента ковариации,
%коэффициента корреляции, суммы модулей разности (нормы Минковского),
%суммы модулей суммы (нормы Поддорогина)

clc;%очистка Command Window
kt=1024; % количество отсчетов
Q=0.2;%шум
kp=4.0%количество периодов сигнала

%1. ГЕНЕРАЦИЯ МОДЕЛЬНОГО СИГНАЛА
for i=1:kt %обнуление массива сигнала
y(i)=0;
end
noise=randn(kt);
%noise=wgn(kt,1,0);
for i=1:kt %генерация модельного сигнала с экспоненциальной модуляцией
w(i)=exp(-20*((i-kt/2)/kt)^2);
y(i)=sin(2*pi*kp*i/kt)*w(i);
y(i)=y(i)+Q*noise(i);
end
i=1:kt; %отображение модельного сигнала во временной области
figure
plot(i,y);
axis tight;
title('Original signal')
xlabel('Sample number')
%2. ФУНКЦИОНАЛЬНОЕ ПРЕОБРАЗОВАНИЕ (БПФ)
bpfy=fft(y,kt);%БПФ
bpf=bpfy.*conj(bpfy)/kt;%БПФ
%нахождение макс. знач. функции БПФ для массива Y
C=max(bpf);
for i=1:kt %поиск количества периодов, соответствующих максимуму БПФ
if (bpf(i)==C)
kpbpf=(i-1);
break
end
end
kp_bpf=kpbpf

%3. СОЗДАНИЕ ЭТАЛОНОВ И КРОССКОРРЕЛЯЦИЯ
kp1=kpbpf;
seach_area=0.8/kp1;%область поиска относит. kp_bpf
for ki=1:3 %количество итераций
shagkor=kp1*seach_area/3;%шаг поиска
k=0;
for j=kp1-kp1*seach_area:shagkor:kp1+kp1*seach_area %цикл для создания 6 эталонов в окрестности приближенного
%значения количества периодов, определенных с помощью БПФ.
k=k+1;
xkor(k)=j;
kor(k)=0;
for i=1:kt
x(i)=0;
end
%Вычисление массивов эталонных сигналов
for i=1:kt
x(i)=sin(2*pi*j*i/kt)*w(i);
end
%вычисление средних значений модельного и эталонных сигналов
x_sr=mean(x);
y_sr=mean(y);
x_sko=0;
y_sko=0;
kor1(k)=0;%%начальное значение показателя сравнения
%вычисление показателя сравнения модельного и эталонных сигналов
for i=1:kt
% x_sko=x_sko+(x(i)-x_sr)*(x(i)-x_sr);
% y_sko=y_sko+(y(i)-y_sr)*(y(i)-y_sr);
% kor(k)=kor(k)+(x(i)-x_sr)*(y(i)-y_sr);%вычисление коэф. ковариации
% sxy(i)=abs(x(i)-y(i));%вычисление модуля разности
% kor1(k)=kor1(k)+sxy(i); %вычисление суммы модулей разности
%(нормы Минковского)
 sxy(i)=abs(x(i)+y(i));%вычисление модуля суммы
 kor1(k)=kor1(k)+sxy(i); %вычисление суммы модулей суммы
%(нормы Поддорогина)
end
% kor1(k)=kor(k)/(sqrt(x_sko*y_sko));%вычисление коэф. корреляции
end %конец цикла создания эталонов и вычисления массива коэф. корр.

%СПЛАЙН-АППРОКСИМАЦИЯ И ПЕРЕДИСКРЕТИЗАЦИЯ
xx=1:k;
xi=1:0.1:k;
r1=sin(xx); %только для тестирования сплайн-аппроксимации
yint=interp1(xx,kor1,xi,'spline');% сплайн-аппроксимация коэф корреляции
r1=kor1;
% apr=spaps(xkor,kor1,0.000001);
figure
% fnplt(apr)
hold on
plot(xkor,r1,'ro');
hold off

%НАХОЖДЕНИЕ УТОЧНЕННОГО ЗНАЧЕНИЯ КОЛИЧЕСТВА ПЕРИОДОВ СИГНАЛА
 cmax=max(yint); %нахождение максимума коэф. корр., ковар.,суммы модулей суммы
% cmax=min(yint); %нахождение минимума коэф. Минковского.
for i=1:round((k-1)/0.1+1)
if (yint(i)==cmax)
kp_int=kp1-kp1*seach_area+(i-1)*shagkor/10; %уточненное значение частоты по МАХ функции коэф. корр.
end
end
seach_area=seach_area/2;
kp1=kp_int;
end
res=kp1

%Нахождение относительной погрешности
%Нахождение относительной погрешности для БПФ
otnositelnya_pogreshnost_bpf=abs((kp_bpf-kp)/kp)*100
%СПЛАЙН-АППРОКСИМАЦИЯ И ПЕРЕДИСКРЕТИЗАЦИЯ
%Нахождение относительной погрешности для АКМ:
xx=1:k;
otnositelnya_pogreshnostr_akm=abs((kp_int-kp)/kp)*100

pause;
close all;%закрытие всех окон графического вывода
clear;%очистка Workspace