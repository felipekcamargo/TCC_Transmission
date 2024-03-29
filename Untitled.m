% Auto-generated by Data Acquisition Toolbox Analog Input Recorder on 23-Jul-2019 16:23:13

%% Create Data Acquisition Session
% Create a session for the specified vendor.
s = daq.createSession('directsound');

%% Add Channels to Session
% Add channels and set channel properties, if any.
addAudioInputChannel(s,'Audio0','1');

%% Acquire Data
% Start the session in foreground.
[data, timestamps, starttime] = startForeground(s);

%% Log Data
% Convert the acquired data and timestamps to a timetable in a workspace variable.
ch1 = data(:,1);
DAQ_3 = timetable(seconds(timestamps),ch1);

%% Plot Data
% Plot the acquired data on labeled axes.
plot(DAQ_3.Time, DAQ_3.Variables)
xlabel('Time')
ylabel('Amplitude (V)')
legend(DAQ_3.Properties.VariableNames)


%Plot para o dom�nio da frequ�ncia
my_fft(data,44100)


%% Clean Up
% Clear the session and channels, if any.
clear s



%% Fun��es

function [X,freq] = my_fft(x,Fs)

N = length(x);                      % vari�vel N recebe o tamanho do vetor x
k = 0:N-1;                          % k � um vetor que vai de zero at� N menos 1
T = N/Fs;                           % Vetor de tempo N dividido pela frequ�ncia de amostragem
freq = k/T;
X = fftn(x)/N;                      % X recebe a FFT normalizada do vetor x sobre N
cutOff = ceil(N/2);                 % cutOff ajusta o eixo X
X = X(1:cutOff);
figure();
plot(freq(1:cutOff),abs(X));        % Plota a transformada de Fourier e o valor de X em m�dulo
title('Fast Fourier Transform');
xlabel('Frequency (Hz)');
ylabel('Amplitude');


end

