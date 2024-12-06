clear; clc; close all;
%% Load data
filename = '1.txt';  
data = load(filename);
% Assuming that the first column is time and the second is sound
time = data(:, 1); 
sound = data(:, 2); 
%% Parameters setup
fs = 65536; % Sampling frequency
duration = 16384; % Number of samples per stage
% Extract noise stage and grinding stage data
x1 = sound(45e4:45e4+duration-1); % Noise stage
x2 = sound(26e5:26e5+duration-1); % Grinding stage
%% 设计高通滤波器/陷波器
% b1 = fir1(1024, 500/ (fs / 2), 'high');    
% x1 = filter(b1, 1, x1);
% x2 = filter(b1, 1, x2);
n = [1 2 3 4 5 6 7];
f0 = 860*n;      % 中心频率（要消除的噪声频率）
Q = 10;       % 质量因数
% 应用陷波器到信号
for i = 1:length(f0)     
    w0 = f0(i) / (fs / 2); % 归一化频率
    bw = w0 / Q;           % 归一化带宽
    [b, a] = iirnotch(w0, bw);    % 设计陷波器
    
    % 应用陷波器到信号
    x1 = filter(b, a, x1);
    x2 = filter(b, a, x2);
end
%% Short-Time Fourier Transform
win = hamming(128); % Window for STFT
overlap = round(numel(win)/2); % 50% overlap
[stft1, f1, t1] = stft(x1, fs, 'Window', win, 'OverlapLength', overlap, 'FFTLength', 4096);
[stft2, f2, t2] = stft(x2, fs, 'Window', win, 'OverlapLength', overlap, 'FFTLength', 4096);
% Get only positive frequencies (up to Nyquist frequency)
startIndex = length(f1)/2+1;
f1 = f1(startIndex:end);
f2 = f2(startIndex:end);
stft1 = stft1((startIndex:end), :);
stft2 = stft2((startIndex:end), :);
%% Normalize STFT Data
maxVal = max(max(abs(stft1(:))), max(abs(stft2(:))));
stft1 = abs(stft1) / maxVal;
stft2 = abs(stft2) / maxVal;
%% Plot the spectrogram
figure;
% Noise stage
subplot(2,1,1);
surf(t1, f1, abs(stft1), 'EdgeColor', 'none');
axis tight;
view(0, 90); % Change the view angle to look from above
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title('Idling Stage');
% Color map configuration for better visualization
colormap turbo;
clim([0 0.4]); 
% clim([0 max(abs(stft1(:)))/2]); % Adjust color scaling
colorbar;
% Grinding stage
subplot(2,1,2);
surf(t2, f2, abs(stft2), 'EdgeColor', 'none');
axis tight;
view(0, 90); % Change the view angle to look from above
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title('Grinding Stage');
% Color map configuration for better visualization
colormap turbo;
clim([0 0.4]); 
% clim([0 max(abs(stft2(:)))/2]); % Adjust color scaling
colorbar;
