%Программа определения частоты короткого сигнала

%Для повышения точности определения количества периодов и частоты
%короткого сигнала используется комбинация
%БПФ, кросскорреляции, сплайн-аппроксимации,передискретизации
% и итерационное уточнение количества периодов
%Предусмотрена возможность использования в качестве показателя
%сравнения исходного и эталонных сигналов коэффициента ковариации,
%коэффициента корреляции, суммы модулей разности (нормы Минковского),
%суммы модулей суммы (нормы Поддорогина)
%Время работы программы при 1024 испытаниях - 1 мин. 20 сек.

kt=1024; % количество отсчетов
shum=0.2 ;%шум
kp=4.0;%количество периодов сигнала

clc;%очистка Command Window
for i4=1:1024 %количество испытаний
%1. ГЕНЕРАЦИЯ МОДЕЛЬНОГО СИГНАЛА
for i=1:kt %обнуление массива сигнала
y(i)=0;
end
%ГЕНЕРАЦИЯ НОРМАЛЬНОГО И БЕЛОГО ШУМА
noise=randn(1024);
%noise=wgn(kt,1,0);
for i=1:kt %генерация модельного сигнала
w(i)=exp(-20*((i-kt/2)/kt)^2);
y(i)=cos(2*pi*kp*i/kt)*w(i);
y(i)=y(i)+shum*noise(i);
end
i=1:kt; %отображение модельного сигнала во временной области

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
kp_bpf=kpbpf;
%3. СОЗДАНИЕ ЭТАЛОНОВ И КРОССКОРРЕЛЯЦИЯ
kp1=kpbpf;
search_area=0.8/kp;%начальная область поиска относит. kp_bpf
for i3=1:3 %задание количества итераций
shagkor=kp1*search_area/3;%шаг поиска
k=0;
for j=kp1-kp1*search_area:shagkor:kp1+kp1*search_area %цикл для создания 6 эталонов в окрестности приближенного
%значения количества периодов, определенных с помощью БПФ.
k=k+1;
xkor(k)=j;
kor(k)=0;
for i=1:kt
x(i)=0;
end
%Вычисление массивов эталонных сигналов
for i=1:kt
x(i)=cos(2*pi*j*i/kt)*w(i);
end
%вычисление средних значений модельного и эталонных сигналов
x_sr=mean(x);
y_sr=mean(y);
x_sko=0;
y_sko=0;
kor1(k)=0;%%начальное значение показателя близости
%вычисление показателя сравнения модельного и эталонных сигналов
for i=1:kt
x_sko=x_sko+(x(i)-x_sr)*(x(i)-x_sr);
y_sko=y_sko+(y(i)-y_sr)*(y(i)-y_sr);
% kor(k)=kor(k)+(x(i)-x_sr)*(y(i)-y_sr);%вычисление коэф.ковариации
% sxy(i)=abs(x(i)-y(i));%вычисление модуля разности !
% sxy(i)= (x(i)-y(i))^2;%вычисление квадрата разности !
sxy(i)=abs(x(i)+y(i));%вычисление модуля суммы !
kor(k)=kor(k)+sxy(i); %вычисление суммы модулей разности, суммы
% квадратов разности, суммы нормы Минковского и Поддорогина !
end
 kor1(k)=kor(k);%вычисление коэф. близости (кроме коэф. корр.)
% kor1(k)=kor(k)/(sqrt(x_sko*y_sko));%вычисление коэф. корреляции
end %конец цикла создания эталонов и вычисления массива коэф. корр.
%СПЛАЙН-ИНТЕРПОЛЯЦИЯ И ПЕРЕДИСКРЕТИЗАЦИЯ
xx=1:k;
xi=1:0.1:k;
yint=interp1(xx,kor1,xi,'spline');% сплайн-аппроксимация коэф корреляции
r1=kor;
%%apr=csaps(xx,r1);
% apr=spaps(xkor,kor,0.00000001);%%%%%%%%%%%%%%%

%НАХОЖДЕНИЕ УТОЧНЕННОГО ЗНАЧЕНИЯ КОЛИЧЕСТВА ПЕРИОДОВ СИГНАЛА
cmax=max(yint); %нахождение максимума коэф. ковар., коэф. корр., коэф. Поддорогина
% cmax=min(yint); %нахождение миниимума коэф.Минковского и суммы квадратов разности.
for i=1:round((k-1)/0.1+1)
if (yint(i)==cmax)
kp_int=kp1-kp1*search_area+(i-1)*shagkor/10; %уточненное значение частоты по МАХ функции коэф. корр.
end
end
kp1=kp_int;%очередное приближение количества периодов
search_area=search_area/2;%сокращение области поиска
end %конец цикла по количеству итераций
kp2(i4)=kp_int;
end %конец цикла стат.испытаний
MO1=mean(kp2)
SKO1=std(kp2)
Confidence_interval=2*SKO1 %Доверительный интервал погрешности при доверительной вероятности 0.95
figure;
hist(kp2, 5); %построение гистограммы. 5 - количество столбцов
pause;
close all;
clear;