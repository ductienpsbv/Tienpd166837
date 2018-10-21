fs = 44100;
t = 0 : 1/fs : (fs-1)/fs; 
f1 = 440; % frequency (Hz)
f2 = 2 * f1
f3 = 3 * f1;
f4 = 4 * f1;
A1 = .3; A2 = A1/2; A3 = A1/3; A4 = A1/4;
w = 0; % phase

y1 = A1 * sin( 2 * pi * f1 * t + w );
y2 = A2 * sin( 2 * pi * f2 * t + w );
y3 = A3 * sin( 2 * pi * f3 * t + w );
y4 = A4 * sin( 2 * pi * f4 * t + w );
y=[y1 y2 y3 y4];
audiowrite('music_input.wav',y,fs); %ghi lai file  melody song sin
recObj = audiorecorder(44100, 16, 2);
disp('Start speaking.')
recordblocking(recObj, 8); %ghi am doc thong tin ca nhan trong 8s
disp('End of Recording.');
myRecording = getaudiodata(recObj);
audiowrite('orig_input.wav',myRecording,fs); %ghi file ghi am
x = audioread('orig_input.wav');
x1 = x(1:2:length(x)); % gan x1=x bien doi de tao melody tu file ghi am
audiowrite('melody_input.wav',x1,fs); % luu file x1 tranh loi MEMORY
x2 = audioread('melody_input.wav');
z = audioread('music_input.wav');
Mix = x2+z; %mix melody giong noi va melody song sin
audiowrite('melody.wav',Mix,fs); %ghi lai file melody yeu cau
soundsc(Mix,fs,16); %phat file melody
% 1.Bien doi FFT file melody
Y = fft(Mix);
plot(abs(Y))

N = fs % number of FFT points
transform = fft(Mix,N)/N;
magTransform = abs(transform);

faxis = linspace(-fs/2,fs/2,N);
plot(faxis,fftshift(magTransform));
xlabel('Frequency (Hz)')

figure;
% 2.Spectrogram file melody
win = 128 % window length in samples
% number of samples between overlapping windows:
hop = win/2            

nfft = win % width of each frequency bin 
spectrogram(Mix,win,hop,nfft,fs,'yaxis')