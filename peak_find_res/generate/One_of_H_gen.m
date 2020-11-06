close all
clear
clc
sw = 5000;                        %�׿�
ss = 20;
c1 = 1;
AI= ceil(4*rand(1));
np = 8096;                        %��������
t = 0:1/sw:(np-1)/sw;
freq=[(ss/(2*np))-5:ss/np:ss-5];
signal = zeros(1,length(t));

wnum = ceil(3 + rand(1)*5);  %��ĸ���
w = round(1000+rand(1, wnum)*3000);   %���λ��
Jnum = randi([0, 3], 1, wnum);     %J�ĸ���Ϊ0~3
label=zeros(1,np); %���ɷ��λ����
n = np/sw;

for ww=1:wnum
    T2=0.1+0.15*rand(1);  %ÿ����T2�ķ�Χ
    H=0.8*rand(1,wnum)+0.2; %ÿ����ķ���ϵ��
    label(round(w(ww)*n))=1; 
    fid1 = H(ww)*exp(1i*(2*pi*(w(ww)))*t).*exp(-t/T2);
    signal = signal + fid1;
    for j = 1:Jnum
        location = (w(ww)-(randsrc(1,1)*((randi([0,100],1,1)/20000)+0.002))*np);
        label(round(location*n))=1;
        fid2 = (H(ww)*((rand(1,1)/5)+0.8))*exp(1i*(2*pi*location)*t).*exp(-t/T2);%ģ����ϵķ�
    signal = signal + fid2;
    end
end

Pnum = randi([0, 3], 1, 1);     %α��ĸ���Ϊ0~3
pw = round(rand(1, Pnum)*np);   %α���λ��

%����ͼ�����α��
for p=1:Pnum
    T2=0.05*rand(1);  %ÿ��α��T2�ķ�Χ
    H=0.4*rand(1,Pnum)+0.3; %ÿ����ķ���ϵ��
    fidp = H(p)*exp(1i*(2*pi*(pw(p)))*t).*exp(-t/T2);
    signal = signal + fidp;
end    

%�����λ�ñ�ǩͼ
figure();
plot(freq,label);
axis([-5,ss-5,-0.5,1]);

%���ɴ�������
pure_real1(1, :) = real(fft(signal,np));
pure = pure_real1/max(max(pure_real1));
figure();
plot(freq,pure);%��Ƶ��ͼ
axis([-5,ss-5,-0.5,1]);

%���ɲ���������
signalnoise=awgn(signal,2,'measured');%����
noise(1, :) = signalnoise; 
impure = real((fft(noise, np)))/max(max(real((fft(noise, np)))));
figure();
plot(freq,impure);%��Ƶ��ͼ
axis([-5,ss-5,-0.5,1]);

data_peak_high=struct('peak_high',label);
save('../test/peak_high.mat');
data_pure=struct('pure',pure);
save('../test/pure.mat');
data_impure=struct('impure',impure);
save('../test/impure.mat');