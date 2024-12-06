clc; close all;
%%
filename = '1.txt';  
data = importdata(filename);

time = data(:, 1); 
sound = data(:, 2); % 非稳态/稳态? 
sampleLength = 10e4;
%% 重采样 
% 为了减少数据分析量，进行重采样 
% fs1 = 65536;
% x = sound(200e4:200e4+sampleLength);
% figure;hua_fft(x,fs1,1);
% fs2 = 16384;
% x1 = resample(x,fs2,fs1);
% figure;hua_fft(x1,fs2,1);
% 结论1：重采样会丢失高频信息，但是一般高频信息中以噪声为主
% 无所需提取的特征信号
%% idling vs. grinding
fs1 = 65536;
x1 = sound(200e4:200e4+sampleLength);
figure;hua_fft(x1,fs1,1);


fs1 = 65536;
x2 = sound(40e4:40e4+sampleLength);
figure;hua_fft(x2,fs1,1);