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
wnum = ceil(3 + rand(1)*10);  %��ĸ���
Jnum = randi(1, 3, wnum);     %J�ĸ���Ϊ1~3
w = round(1000+rand(1, wnum)*3000);   %���λ��
for ww=1:wnum
    T2=0.1+0.15*rand(1);  %ÿ��c��T2�ķ�Χ
    M00=0.6*rand(1,wnum); %ÿ����ķ���ϵ��cc
    tt00 = M00(ww)*exp(1i*(2*pi*(w(ww)))*t).*exp(-t/T2);
    signal = signal + tt00;
end

%���ɷ��λ����
label=zeros(1,np);
n = np/sw;
for i=1:wnum
   label(round(w(i)*n))=1; 
end
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
signalnoise=awgn(signal,100,'measured');%����
noise(1, :) = signalnoise; 
impure = real((fft(noise, np)))/max(max(real((fft(noise, np)))));
figure();
plot(freq,impure);%��Ƶ��ͼ
axis([-5,ss-5,-0.5,1]);

data_peak=struct('peak',label);
save('../test/peak.mat');
data_pure=struct('pure',pure);
save('../test/pure.mat');
data_impure=struct('impure',impure);
save('../test/impure.mat');