clear; close all;
%% 加载数据
filename = '1.txt';  
data = load(filename);
time = data(:, 1); 
sound = data(:, 2); 
%% 参数设置
fs = 65536; % 采样频率
duration = 16384; % 每个阶段的样本数量
% 提取噪声阶段和磨削阶段的数据
x1 = sound(45e4:45e4+duration-1); % 噪声阶段
x2 = sound(26e5:26e5+duration-1); % 磨削阶段

% 画时域图
t = (0:length(x2)-1)/fs;
figure
plot (t, x2);
set(gcf,'Position',[300 300 400 400]);%消除白边
set(gca,'Position',[0 0 1 1]);%消除白边
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w');

% 完整时域图
t = (0:length(sound)-1)/fs;
figure
plot (t, sound);
ylim([-10 10]); 
ylabel("Sound pressure (Pa)");
xlabel("Time (s)");

% 画频谱图
figure;
% subplot(2,1,1)
hua_fft(x1,fs,1);
xlim([0 20000]); 
% ylim([-10 10]); 
% xlabel("Frequency (Hz)");
% ylabel("Amplitude");
% title('Noise Stage');

ax2 = figure;
% subplot(2,1,2)
hua_fft(x2,fs,1);
xlim([0 20000]); 
% xlabel("Frequency (Hz)");
% ylabel("Amplitude");
% title('Grinding Stage');

%% 画包络谱
figure;
subplot(2,1,1)
hua_baol(x1,fs,1);
% xlim([0 100]); 
% ylim([-10 10]); 
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title('Noise Stage');
subplot(2,1,2)
hua_baol(x2,fs,1);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title('Grinding Stage');
