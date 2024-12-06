clc;clear;close all
%%
fs=12000;
N=12000;
t=(0:N-1)/fs;
fn=3200;
kesi=0.05;
x1=exp(-kesi*2*pi*fn*t);
x2=sin(2*pi*fn*t);
s=x1.*x2;
fr=30;
A0=4;
Ai=A0*cos(2*pi*fr*t+pi/2)+0.5;
fm=100;
B0=1;
B=B0*cos(2*pi*fm*t)+B0*cos(2*pi*50*t);
ff=161;   % 161Hz 轴承1 外圈故障
S0=s;
S=S0;
for i=1:floor(length(t)/(fs/ff))-1    
    S=S+[zeros(1,floor(fs/ff*i+0.01*fs/ff)) S0(1:length(S)-floor(i*fs/ff+0.01*fs/ff))];  
end
ff=Ai.*S;
f1=S;     % 有效特征/信号 增强

x = awgn(f1,0,'measured') + B;

% figure;
% plot(t,x);
% 
% figure;
% hua_fft(x,fs,1);
% 
% figure;
% hua_baol(x,fs,1,0,700);


%%
imf = emd(x);
[m,n] = size(imf);

figure;
for j = 1:n
    subplot(n,1,j);
    plot(t,imf(:,j));
    ylabel(['imf',num2str(j)]);
end

figure;
for j = 1:n
    subplot(n,1,j);
    hua_fft(imf(:,j),fs,1);
    ylabel(['imf',num2str(j)]);
end

zb = [];
for j = 1:n
    zb(j) = kurtosis(imf(:,j));
end

xc = imf(:,1) + imf(:,2) +imf(:,3);


figure;
hua_baol(xc,fs,1,0,700);

