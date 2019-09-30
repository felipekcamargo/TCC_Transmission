%% Create Data Acquisition Session
% Create a session for the specified vendor.
s = daq.createSession('directsound');

%% Set Session Properties
% Set properties that are not using default values.
s.Rate = 44100;
s.NumberOfScans = 2940%44100; 

%% Add Channels to Session
% Add channels and set channel properties, if any.
addAudioInputChannel(s,'Audio0','1');

%% Acquire Data
% Start the session in foreground.
[data, timestamps, starttime] = startForeground(s);

%% Log Data
% Convert the acquired data and timestamps to a timetable in a workspace variable.
ch1 = data(:,1);
DAQ_2 = timetable(seconds(timestamps),ch1);

%% Plot Data

%Plot para o domínio da frequência
control = 0;
ampli=[];
Xiz=[];
saidaFinal=[];
contador=1;
while(contador<=60)
    [Xiz,ampli,saidaFinal(contador)]=my_fft(DAQ_2.Variables,44100);
    %pause(0.25)
    %fprintf('Worked!');
    [data, timestamps, starttime] = startForeground(s);
    ch1 = data(:,1);
    DAQ_2 = timetable(seconds(timestamps),ch1);
    contador=contador+1;
end
  
plot(contador,saidaFinal)
xlabel('Time')
ylabel('Amplitude (V)') 
% Plot the acquired data on labeled axes.
%figure
%plot(DAQ_2.Time, DAQ_2.Variables)
%xlabel('Time')
%ylabel('Amplitude (V)')
%legend(DAQ_2.Properties.VariableNames)



%% Clean Up
% Clear the session and channels, if any.
clear s

%% Função que passa para o dominio da frequencia

function [X,freq,saida] = my_fft(x,Fs)

N = length(x);                      % variável N recebe o tamanho do vetor x
k = 0:N-1;                          % k é um vetor que vai de zero até N menos 1
T = N/Fs;                           % Vetor de tempo N dividido pela frequência de amostragem
freq = k/T;
X = fftn(x)/N;                      % X recebe a FFT normalizada do vetor x sobre N
cutOff = ceil(N/2);                 % cutOff ajusta o eixo X
X = X(1:cutOff);
saida=0;
%figure();
frequency = freq(1:cutOff);
amplitude = abs(X);
%plot(frequency, amplitude);        % Plota a transformada de Fourier e o valor de X em módulo
%title('Fast Fourier Transform');
%xlabel('Frequency (Hz)');
%ylabel('Amplitude');
count = 0;
j=397;
while j<=407%407 é o id para as frequencias de 5900 e pouco a 6050 e poucos Hz
            %entao ele verifica se existe valores numa certa amplitude para
            %essas frequencias no if abaixo.
    %amplitude(j,1)
    if amplitude(j,1)>=0.000001 %verificar montagem do vetor
        saida=amplitude(j,1);%1;
    end
    j=j+1;
end
% while count < 200
%     if amplitude(count+6000) > 1.5e-07
%         fprintf('Worked!');
%         break;
%     end
%     count = count + 1;
% end

end

