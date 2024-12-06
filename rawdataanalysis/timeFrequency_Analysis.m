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

%% 设置 STFT 参数
windowSize = 256; % 窗口大小
overlap = round(0.75 * windowSize); % 重叠大小（例如75%）
nfft = 512; % FFT的点数
% window = hamming (window); % 窗口函数 hamming window
% t = (1:n)/fs;
%% 应用短时傅里叶变换
% [s,f,t] = spectrogram(signal,window,noverlap,fc,fs);
[S, F, T] = stft(sound, fs, 'Window', hamming(windowSize), 'OverlapLength', overlap, 'FFTLength', nfft);
%% 画stft时频图
figure;
surf(T, F, 10*log10(abs(S)), 'EdgeColor', 'none');
axis tight;
colormap jet;
shading interp;
view(0, 90);
colorbar;
ylim([0 20000])
xlabel('Time (Seconds)');
ylabel('Frequency (Hz)');
title('Short-time Fourier Transform');

%% 设置 CWT 参数
duration = 16384; % 每个阶段的样本数量
% 提取噪声阶段和磨削阶段的数据
x1 = sound(45e4:45e4+duration-1); % 噪声阶段
x2 = sound(26e5:26e5+duration-1); % 磨削阶段


%% 连续小波变换
        [wt, frq] = cwt(sound, fs);  % 连续小波变换


%% 绘制时频图
figure

        hp = pcolor(t,frq,abs(wt));
        hp.EdgeColor = "interp";
        % imagesc(t,frq,abs(wt)); 
        % shading interp
        colormap jet;          % colormap turbo;
        colorbar;

xlim([0 0.25])
ylim([0 20000])
clim ([0 1]);
xlabel ('Time(s)');
ylabel ('Frequency(Hz)');
title ('Continuous Wavelet Transform'); 
axis xy


