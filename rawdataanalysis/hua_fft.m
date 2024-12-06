function hua_fft(y,fs,style,varargin)
%当style=1,画幅值谱；当style=2,画功率谱;当style=其他的，那么画幅值谱和功率谱
%对随机信号分析，功率谱才是有效的
%当style=1时，还可以多输入2个可选参数
%可选输入参数是用来控制需要查看的频率段的
%第一个是需要查看的频率段起点
%第二个是需要查看的频率段的终点
%其他style不具备可选输入参数，如果输入发生位置错误
nfft= 2^nextpow2(length(y));%找出大于y的个数的最大的2的指数值（自动计算最佳FFT步长nfft）
%nfft=1024;%人为设置FFT的步长nfft
y=y-mean(y);%去除直流分量，要不然第一个点的幅值很大
y_ft=fft(y,nfft)/length(y);%对y信号进行DFT，得到频率的幅值分布
y_p=y_ft.*conj(y_ft)/nfft;%conj()函数是求y函数的共轭复数，实数的共轭复数是他本身。相当于求模值
y_f=fs*(0:nfft/2-1)/nfft;%DFT变换后对应的频率的序列
if style==1
    if nargin==3
        plot(y_f,2*abs(y_ft(1:nfft/2)));%matlab的帮助里画FFT的方法
        %ylabel('幅值');xlabel('频率');title('信号幅值谱');
        %plot(y_f,abs(y_ft(1:nfft/2)));%论坛上画FFT的方法
    else
        f1=varargin{1};
        fn=varargin{2};
        ni=round(f1 * nfft/fs+1);
        na=round(fn * nfft/fs+1);
        plot(y_f(ni:na),abs(y_ft(ni:na)*2));
    end

elseif style==2
            plot(y_f,log10(abs(y_ft(1:nfft/2))));
            ylabel('功率谱密度');xlabel('频率');title('信号功率谱');
    else
        subplot(211);plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));
        ylabel('幅值');xlabel('频率');title('信号幅值谱');
        subplot(212);plot(y_f,y_p(1:nfft/2));
        ylabel('功率谱密度');xlabel('频率');title('信号功率谱');
end
end