clear; clc; close all;
%% 加载数据
filename = '1.txt';  
data = load(filename);
time = data(:, 1); 
sound = data(:, 2); 
[m,n]=size(sound);
fs = 65536; % 采样频率
% t=(1:m)/fs;
% t = t/60;
%% 参数设置
duration = 16384; % 每个阶段的样本数量
% 提取噪声阶段和磨削阶段的数据
x1 = sound(45e4:45e4+duration-1); % 噪声阶段
x2 = sound(26e5:26e5+duration-1); % 磨削阶段

%% 设计高通滤波器
% b1 = fir1(1024, 500/ (fs / 2), 'high');    
% x1 = filter(b1, 1, x1);
% x2 = filter(b1, 1, x2);
%% 设计陷波器
% n = [1 2 3 4 5 6 7];
% f0 = 860*n;      % 中心频率（要消除的噪声频率）
% Q = 10;       % 质量因数
% % 应用陷波器到信号
% for i = 1:length(f0)     
%     w0 = f0(i) / (fs / 2); % 归一化频率
%     bw = w0 / Q;           % 归一化带宽
%     [b, a] = iirnotch(w0, bw);    % 设计陷波器
% 
%     % 应用陷波器到信号
%     x1 = filter(b, a, x1);
%     x2 = filter(b, a, x2);
% end
%% 连续小波变换
        [wt, frq] = cwt(sound, fs);  % 连续小波变换
[cfs1,frq1] = cwt(x1,fs);
[cfs2,frq2] = cwt(x2,fs);
%% 绘制时频图
figure
% 噪声阶段
subplot(2,1,1);
t = (0:length(cfs1)-1) / fs; % 计算时间向量
surface(t,frq1,abs(cfs1)); % 绘制时频表面
axis tight; % 紧凑显示
shading flat; % 阴影平坦
colormap turbo;
clim([0 1]); 
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title('Idling Stage');
colorbar;
% 磨削阶段
subplot(2,1,2);
t = (0:length(cfs2)-1) / fs; % 计算时间向量
surface(t,frq2,abs(cfs2)); % 绘制时频表面
axis tight; % 紧凑显示
shading flat; % 阴影平坦
colormap turbo;
clim([0 1]); 
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title('Grinding Stage');
colorbar;

