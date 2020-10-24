close all
clear
clc

sw = 5000;                        %�׿�
c1=1;                             %�ױ�ǣ���1��ʼ
AI= ceil(4*rand(1));
np = 2048;                        %��������
t = 0:1/sw:(np-1)/sw;
signal = zeros(1,length(t));
tt = ones(1, length(t));
spec_X=[];
spec_Y=[];
total_spec_X=[];
total_spec_Y=[];

for a=1:1000  
 wnum = ceil(3 + rand(1)*10);  %��ĸ���
 Jnum = randi(1, 3, wnum);     %J�ĸ���Ϊ1~3
 w = 1000+rand(1, wnum)*3000;   %���λ��
 J = 10*rand(wnum, 3)+2;       %J�ķ�ΧΪ2~12
 pow = randi(20, wnum, 3) - ones(wnum, 3);  %��ͬ�����
 signal00 = zeros(1,length(t));
 for ww=1:wnum
    T2=0.1+0.15*rand(1);  %ÿ����T2�ķ�Χ
    M00=0.6*rand(1,wnum); %ÿ����ķ���ϵ��
    tt00 = M00(ww)*exp(1i*(2*pi*(w(ww)))*t).*exp(-t/T2);
    for z=1:Jnum
        tt00 = tt00.*cos(pi*J(ww, z)*t).^pow(ww, z);
    end
    signal00 = signal00 + tt00;
 end

 signal01=awgn(signal00,2,'measured');
 signal02=awgn(signal00,4,'measured');
 signal03=awgn(signal00,8,'measured');
 signal04=awgn(signal00,16,'measured');
 pure_real1(1, :) = real(fft(signal00,np));

 noise01(1, :) = signal01;
 noise02(1, :) = signal02;
 noise03(1, :) = signal03;
 noise04(1, :) = signal04;      

 pure1 = pure_real1/max(max(pure_real1));

 pure=pure1;


 impure01 = real((fft(noise01, np)))/max(max(real((fft(noise01, np)))));
 impure02 = real((fft(noise02, np)))/max(max(real((fft(noise02, np)))));
 impure03 = real((fft(noise03, np)))/max(max(real((fft(noise03, np)))));
 impure04 = real((fft(noise04, np)))/max(max(real((fft(noise04, np)))));



 impure1=[impure01
         impure02
         impure03
         impure04];

 impure=impure01;
 
 spec_X=[spec_X;impure];  
 spec_Y=[spec_Y;pure];
 if rem(c1, 500) == 0
    total_spec_X=[total_spec_X;spec_X]; 
    total_spec_Y=[total_spec_Y;spec_Y]; 
    spec_X=[];
    spec_Y=[];
 end
c1=c1+1;
end

data=struct('data_x',total_spec_X);
save('../data/data_pure.mat','data');
data=struct('data_y',total_spec_Y);
save('../data/data_impure.mat','data');