close all
clear
clc

sw = 5000;                        %�׿�
c1 = 1;
AI= ceil(4*rand(1));
np = 8096;                        %��������
t = 0:1/sw:(np-1)/sw;
signal = zeros(1,length(t));
tt = ones(c1, length(t));

wnum = ceil(3 + rand(1)*10);  %��ĸ���c
Jnum = randi(1, 3, wnum);     %J�ĸ���Ϊ1~3
w = 1000+rand(1, wnum)*3000;   %���λ��c
J = 10*rand(wnum, 3)+2;       %J�ķ�ΧΪ2~12
pow = randi(20, wnum, 3) - ones(wnum, 3);  %��ͬ�����
for ww=1:wnum
    T2=0.1+0.15*rand(1);  %ÿ��c��T2�ķ�Χ
    M00=0.6*rand(1,wnum); %ÿ����ķ���ϵ��
    tt00 = M00(ww)*exp(1i*(2*pi*(w(ww)))*t).*exp(-t/T2);
    for z=1:Jnum %
        tt00 = tt00.*cos(pi*J(ww, z)*t).^pow(ww, z);
    end
    signal = signal + tt00;
end

%���ɴ�������
pure_real1(1, :) = real(fft(signal,np));
pure = pure_real1/max(max(pure_real1));
figure();
plot(pure);%��Ƶ��ͼ
axis([0,np,-0.5,1]);

%���ɲ���������
signalnoise=awgn(signal,100,'measured');%����
noise(1, :) = signalnoise; 
impure = real((fft(noise, np)))/max(max(real((fft(noise, np)))));
figure();
plot(impure);%��Ƶ��ͼ
axis([0,np,-0.5,1]);

data=struct('data_x',pure);
save('../test/pure.mat','data');
data=struct('data_y',impure);
save('../test/impure.mat','data');