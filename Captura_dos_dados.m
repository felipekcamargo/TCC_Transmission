%receptor
stopALL=0;
triggerS=0;
while stopALL==0
% Auto-generated by Data Acquisition Toolbox Analog Input Recorder on 03-Oct-2019 19:38:59

%% Create Data Acquisition Session
% Create a session for the specified vendor.
s = daq.createSession('directsound');

%% Set Session Properties
% Set properties that are not using default values.
s.IsContinuous = 1;

%% Add Channels to Session
% Add channels and set channel properties, if any.
addAudioInputChannel(s,'Audio1','1');

%% Initialize Session UserData Property
% Initialize the custom fields for managing the acquired data across callbacks.
s.UserData.Data = [];
s.UserData.TimeStamps = [];
s.UserData.StartTime = [];

%% Add Listeners
% Add listeners to session for available data and error events.
lh1 = addlistener(s, 'DataAvailable', @recordData);
lh2 = addlistener(s, 'ErrorOccurred', @(~,eventData) disp(getReport(eventData.Error)));

%% Acquire Data 
% Start the session in the background.
startBackground(s)
if triggerS~=0
    tempodecaptura=1;
else
    tempodecaptura=5.5;
end
pause(tempodecaptura) % Increase or decrease the pause duration to fit your needs.
stop(s)

%% Log Data
% Convert the acquired data and timestamps to a timetable in a workspace variable.
ch1 = s.UserData.Data(:,1);
DAQ_2 = timetable(seconds(s.UserData.TimeStamps),ch1);

%% %plot Data
% %plot the acquired data on labeled axes.
resultado=[0,0,0,0,0];

if(triggerS~=0)
    
    %pause(500000)
else %identifica se sinal existe e seta o trigger
    triggerS=0;
    numerodeBits=11;
    f_desejada=20000;
    Samp_freq=132300;
    len_daq=length(DAQ_2.Variables);
    ganhoBits=10000;
    [teste_passa_faixa,teste_bits]=interpretaBits(DAQ_2.Variables,f_desejada+500,f_desejada-500,length(DAQ_2.Variables)/numerodeBits,numerodeBits,length(DAQ_2.Variables)/tempodecaptura,ganhoBits);
    plot(teste_passa_faixa)
    xlabel('Time')
    ylabel('Amplitude (V)')
    legend(DAQ_2.Properties.VariableNames)
    teste_bits;
    if teste_bits(1)==1 && teste_bits(2)==0 && teste_bits(3)==1 && teste_bits(9)==1 && teste_bits(10)==1 && teste_bits(11)==1
		resultado=[teste_bits(4),teste_bits(5),teste_bits(6),teste_bits(7),teste_bits(8)];
		stopALL=1;

    elseif teste_bits(2)==1 && teste_bits(3)==0 && teste_bits(4)==1 && teste_bits(10)==1 && teste_bits(11)==1 && teste_bits(1)==1
		resultado=[teste_bits(5),teste_bits(6),teste_bits(7),teste_bits(8),teste_bits(9)];
		stopALL=1;
	elseif teste_bits(3)==1 && teste_bits(4)==0 && teste_bits(5)==1 && teste_bits(11)==1 && teste_bits(1)==1 && teste_bits(2)==1
		resultado=[teste_bits(6),teste_bits(7),teste_bits(8),teste_bits(9),teste_bits(10)];
		stopALL=1;        

	elseif teste_bits(4)==1 && teste_bits(5)==0 && teste_bits(6)==1 && teste_bits(1)==1 && teste_bits(2)==1 && teste_bits(3)==1
		resultado=[teste_bits(7),teste_bits(8),teste_bits(9),teste_bits(10),teste_bits(11)];
		stopALL=1;        

	elseif teste_bits(5)==1 && teste_bits(6)==0 && teste_bits(7)==1 && teste_bits(2)==1 && teste_bits(3)==1 && teste_bits(4)==1
		resultado=[teste_bits(8),teste_bits(9),teste_bits(10),teste_bits(11),teste_bits(1)];
		stopALL=1;        

	elseif teste_bits(6)==1 && teste_bits(7)==0 && teste_bits(8)==1 && teste_bits(3)==1 && teste_bits(4)==1 && teste_bits(5)==1
		resultado=[teste_bits(9),teste_bits(10),teste_bits(11),teste_bits(1),teste_bits(2)];
		stopALL=1;        

	elseif teste_bits(7)==1 && teste_bits(8)==0 && teste_bits(9)==1 && teste_bits(4)==1 && teste_bits(5)==1 && teste_bits(6)==1
		resultado=[teste_bits(10),teste_bits(11),teste_bits(1),teste_bits(2),teste_bits(3)];
		stopALL=1;        

	elseif teste_bits(8)==1 && teste_bits(9)==0 && teste_bits(10)==1 && teste_bits(5)==1 && teste_bits(6)==1 && teste_bits(7)==1
		resultado=[teste_bits(11),teste_bits(1),teste_bits(2),teste_bits(3),teste_bits(4)];
		stopALL=1;        

	elseif teste_bits(9)==1 && teste_bits(10)==0 && teste_bits(11)==1 && teste_bits(6)==1 && teste_bits(7)==1 && teste_bits(8)==1
		resultado=[teste_bits(1),teste_bits(2),teste_bits(3),teste_bits(4),teste_bits(5)];
		stopALL=1;        

	elseif teste_bits(10)==1 && teste_bits(11)==0 && teste_bits(1)==1 && teste_bits(7)==1 && teste_bits(8)==1 && teste_bits(9)==1
		resultado=[teste_bits(2),teste_bits(3),teste_bits(4),teste_bits(5),teste_bits(6)];
		stopALL=1;        

	elseif teste_bits(11)==1 && teste_bits(1)==0 && teste_bits(2)==1 && teste_bits(8)==1 && teste_bits(9)==1 && teste_bits(10)==1
		resultado=[teste_bits(3),teste_bits(4),teste_bits(5),teste_bits(6),teste_bits(7)];
		stopALL=1;        

    else
        pause(0.5*tempodecaptura/numerodeBits)
    end
    
    if (resultado(1)==1 && resultado(2)==1 && (resultado(3)==1 || (resultado(4)==1 && resultado(5)==1))) || (resultado(1) ==0 && resultado(2) ==0 && resultado(3) ==0 && resultado(4) ==0 && resultado(5) ==0)  
        a="Nenhuma mensagem recebida ou codigo ASCII invalido"
        stopALL=0;
    elseif stopALL==1
        resultado
        captura = flip(resultado);
        bitToChar(captura)
        %codigo do felipe
    end
    
end
    
%% Clean Up
% Remove event listeners and clear the session and channels, if any.
delete(lh1)
delete(lh2)
clear s lh1 lh2
end
%% Callback Function
% Define the callback function for the 'DataAvailable' event.

function [saida] = bitToChar(bits) 
saida = char(bi2de(bits)+ 64)
end


function recordData(src, eventData)
% RECORDDATA(SRC, EVENTDATA) records the acquired data, timestamps and
% trigger time. You can also use this function for plotting the
% acquired data live.

% SRC       - Source object      i.e. Session object
% EVENTDATA - Event data object  i.e. 'DataAvailable' event data object

% Record the data and timestamps to the UserData property of the session.
src.UserData.Data = [src.UserData.Data; eventData.Data];
src.UserData.TimeStamps = [src.UserData.TimeStamps; eventData.TimeStamps];

% Record the starttime from the first execution of this callback function.
if isempty(src.UserData.StartTime)
    src.UserData.StartTime = eventData.TriggerTime;
end

% Uncomment the following lines to enable live plotting.
% %plot(eventData.TimeStamps, eventData.Data)
% xlabel('Time (s)')
% ylabel('Amplitude (V)')
% legend('ch1')
end

%% Interpreta bits
% Função para a interpretação de bits
function [sinal_interpretado,bits_recebidos] = interpretaBits(sinal_N_interpret,frequencia_corte_sup,frequencia_corte_inf,bit_dur,quantBits,Fs,valormult)
    hp=bandpass(sinal_N_interpret,[frequencia_corte_inf frequencia_corte_sup],Fs);
    mediaBits=zeros(1,quantBits);
    counter_bits=0;
    media_Sinal=max(abs(hp))+min(abs(hp))/2;
    for i =1:length(sinal_N_interpret)
       if (i-(counter_bits*bit_dur))<=bit_dur-1 && counter_bits<=quantBits-1
           mediaBits(1,counter_bits+1)=mediaBits(1,counter_bits+1)+abs(hp(i,1));

       else
           if counter_bits<=quantBits-1
               mediaBits(1,counter_bits+1)=mediaBits(1,counter_bits+1)+abs(hp(i,1));
               mediaBits(1,counter_bits+1)=mediaBits(1,counter_bits+1)/bit_dur;
               %floor(mediaBits(1,counter_bits+1));
               counter_bits=counter_bits+1;
           end
       end
    end
    for i=1:quantBits
        mediaBits(1,i);
        %if floor(mediaBits(1,i)*valormult)<=0
        if mediaBits(1,i)<media_Sinal*0.22
            mediaBits(1,i)=0;
        else
            mediaBits(1,i)=1;
        end
    end
    bits_recebidos=mediaBits;
    sinal_interpretado=hp;
end