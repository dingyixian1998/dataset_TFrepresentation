clc; clear; close all;
% load('grindingClass_0.25s.mat');
% grindingClass = cell2mat(grindingClass);
% signal = grindingClass(1,:);  % 只取第一行信号进行分析
filename = '1.txt';  
data = importdata(filename);

time = data(:, 1); 
sound = data(:, 2); % 非稳态/稳态? 
fs = 65536;  % 采样频率 
sampleLength = 10e4;   
idling = sound(40e4:40e4+sampleLength);   %  16384
grinding = sound(200e4:200e4+sampleLength);  %  16384
signal = grinding;

%% 设置小波包分解参数
level = 3; % 分解级别/分解层数 decomposition level
wname = 'db4';  % 使用Daubechies小波
% Best-localized Daubechies, Beylkin, Coiflets, Daubechies, 
% Fejér-Korovkin, Haar, Han linear-phase moments, Morris minimum-bandwidth, 
% Symlets, Vaidyanathan, Discrete Meyer, Biorthogonal, and Reverse Biorthogonal.
entropy = 'shannon'; % 默认是使用香农熵
% "shannon" | "log energy" | "threshold" | "sure" | "norm" | "user" | "FunName"
%% 执行小波包分解
tobj = wpdec(signal, level, wname, entropy);  % 执行小波包分解
plot (tobj); % 小波包树可视化
% [~, coeffNodes] = wprcoef(wp);  % 获取所有节点的系数
%% 设置连续小波变换系数
Wavelet = 'morse'; 
% Morse wavelet: 'bump'
% Morlet wavelet: 'morse'
% bump wavelet: 'amor'
%% 选择绘制特定节点的信号 
numNodes = length(tnodes(tobj));
fprintf('Total number of nodes in the wavelet packet decomposition: %d\n', numNodes);
for i = 1:numNodes
    nodeSignal = wpcoef(tobj, [level i-1]);  % 获取第level个分解级数的第i个节点的系数 
    figure; 
    subplot(2,1,1);   % 绘制节点信号
    t = (0:length(nodeSignal)-1)/fs;
    plot(t,nodeSignal);
    title(['Packet [', num2str(level), ' ', num2str(i-1), '] Time domain']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([min(t) max(t)]); % 设置x轴限制以匹配信号时间范围
    
    subplot(2,1,2);  % 绘制节点信号的时频图
    [cfs, freqs] = cwt(nodeSignal, Wavelet, fs);  % 连续小波变换
    surf(t, freqs, abs(cfs), 'edgecolor', 'none');
    axis tight;
    shading interp;
    view(0, 90);
    % view(90,0)
    title(['Packet [', num2str(level), ' ', num2str(i-1), '] ' 'Time-frequency sepectrum']);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    colormap jet;
    % colorbar; 
end
%% 绘制不同节点的信号时域对比 

























