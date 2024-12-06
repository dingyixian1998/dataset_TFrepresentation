clear; clc; close all;
% 导入数据
filename = '1.txt';  
data = importdata(filename);
time = data(:, 1); 
sound = data(:, 2); 
%% 参数设置
fs = 65536; % 采样频率
duration = 16384; % 每个阶段的样本数量
% 提取噪声阶段和磨削阶段的数据
x1 = sound(45e4:45e4+duration-1); % 噪声阶段
x2 = sound(26e5:26e5+duration-1); % 磨削阶段
x = x1;
% 减少数据量，进行重采样
% fs = 16384; % 新采样率
% x1 = resample(x, fs, fs1); % 重采样
%% 设计滤波器
% b1 = fir1(128, 5000/ (fs / 2), 'high');    
% b = b1; 
% x1 = filter(b, 1, x1);
% x2 = filter(b, 1, x2);
%% 应用经验模态分解 (EMD)
imf = emd(x);
t = (0:length(x)-1) / fs; % 时间向量
% 绘制 IMFs 的时域图
[m, n] = size(imf);
figure;
for j = 1:n
    subplot(n, 1, j);
    plot(t, imf(:, j));
    ylabel(['IMF ', num2str(j)]);
end
sgtitle('IMFs in Time Domain');
% 绘制 IMFs 的频域图
figure;
for j = 1:n
    subplot(n, 1, j);
    hua_fft(imf(:, j), fs, 1); 
    ylabel(['IMF ', num2str(j)]);
end
sgtitle('IMFs in Frequency Domain');
% 绘制 IMFs 的时频图
figure;
for j = 1:n
    subplot(n, 1, j);
    [cfs,frq] = cwt(imf(:, j), 'bump', fs);  % 使用 'bump' 小波进行CWT
    % 绘制时频图
    t = (0:length(imf(:, j))-1) / fs;
    pcolor(t, frq, abs(cfs));  % 绘制时频表示
    shading interp;  % 使颜色平滑过渡
    colormap 'jet';  % 使用jet颜色图
    ylabel(['IMF ', num2str(j)]);
    ylim([min(frq) max(frq)]);  % 设置y轴的范围为频率范围
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
end
sgtitle('IMFs in Time-frequency Domain');


%% 重构信号
% reconstructed_signal = sum(imf(:, 2:end), 2); % 修改此处，从第二列开始求和
% % 绘制原始信号和重构信号进行比较
% figure;
% subplot(2, 1, 1); % 绘制原始信号：2行1列的第1个
% plot(t, x2, 'b');
% title('Original Signal');
% xlabel('Time (s)');
% ylabel('Amplitude');
% legend('Original Signal');
% subplot(2, 1, 2); % 绘制重构信号：2行1列的第2个
% plot(t, reconstructed_signal, 'r--');
% title('Reconstructed Signal');
% xlabel('Time (s)');
% ylabel('Amplitude');
% legend('Reconstructed Signal');
