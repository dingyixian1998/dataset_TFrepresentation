clear; clc; close all;
%% 加载数据
filename = '1.txt';  
data = load(filename);
time = data(:, 1); 
sound = data(:, 2); 
%% 信号截取
duration = 16384; % 每个阶段的样本数量
% 提取噪声阶段和磨削阶段的数据
x1 = sound(45e4:45e4+duration-1); % 噪声阶段
x2 = sound(26e5:26e5+duration-1); % 磨削阶段
%% 设定参数
n = [1 2 3 4 5 6 7];
f0 = 860*n;      % 中心频率（要消除的噪声频率）
fs = 65536;    % 采样频率
Q = 10;       % 质量因数

% % 为每个中心频率设计一个陷波器并显示其频率响应
% for i = 1:length(f0)
%     % 计算归一化频率和带宽
%     w0 = f0(i) / (fs / 2); % 归一化频率
%     bw = w0 / Q;           % 归一化带宽
%     [b, a] = iirnotch(w0, bw);     % 设计陷波器
% 
%     % 显示陷波器的频率响应
%     fvtool(b, a);
% end

%% 应用陷波器
% 初始化滤波后的信号
x1_filtered = x1;
x2_filtered = x2;
% 应用陷波器到信号
for i = 1:length(f0)     
    w0 = f0(i) / (fs / 2); % 归一化频率
    bw = w0 / Q;           % 归一化带宽
    [b, a] = iirnotch(w0, bw);    % 设计陷波器
    
    % 应用陷波器到信号
    x1_filtered = filter(b, a, x1_filtered);
    x2_filtered = filter(b, a, x2_filtered);
end

% 可视化结果
figure;
subplot(2,1,1)
hua_fft(x1_filtered,fs,1);
ylim([0 0.3]); % 设置 Y 轴范围
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title('Idling Stage');
subplot(2,1,2)
hua_fft(x2_filtered,fs,1);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title('Grinding Stage');





