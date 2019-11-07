%transmissor

infor=[0,0,0,0,1]; % 'A'
repeat=1;
                                       % Length (sec)
tempoPorBit=.5;
bitsIni=[1,0,1]
bitsFin=[1,1,1]
infor=[bitsIni infor bitsFin]
len = length(infor)*tempoPorBit;
%emite_trigger(1)
%emite_info([1,0,1],repeat,3)
%pause(length([1,0,1]))
for i=1:16
    emite_info(infor,repeat,len)
    pause(len-.8);
    i=i+1;
end
%pause(len)
%emite_info([1,0,1],repeat,3)



function emite_info(infor,repeat,len)
    length(infor);
    f= 20000;                                     % Frequency (Hz)
    f3= 21000;
    Fs= 199192;                                     % Sampling Frequency (Hz)
    t = linspace(0, len, Fs*len);                 % Time Vector
    infSignal=sin(2*pi*f*t);
    rpts=length(infSignal)/repeat;
    iSig=rpts/length(infor); %duração de 1 bit
    for l=1:repeat
        j=1;
        for z=1:rpts
            time=round(z+((l-1)*rpts),0);
            if infor(1,j)==0
                infSignal(1,time)=0;
            end
            if infor(1,j)==1
                infSignal(1,time)=1;
            end
            if j*iSig==z
               j=j+1;

            end
        end
        l=l+1;
    end
    signal = sin(2*pi*f*t);                         % Signal (10 kHz sine)
    signal3= sin(2*pi*f3*t);
    mxSignal=signal;%+signal2+signal3;
    for i=1:length(mxSignal)
        if infSignal(1,i)==0
            mxSignal(1,i)=signal3(1,i);

        else
            mxSignal(1,i)=signal(1,i);
        end

    end

    sound(mxSignal,Fs)
    %plot(mxSignal)

    %noise = signal + 0.1*randn(size(signal));
    %interpretaBits(mxSignal,f+100,f-100,iSig,length(infor),Fs,4)
end
function emite_trigger(duracaoTrigger)
    len=duracaoTrigger;
    infor=[1,0];
    repeat=1;
    length(infor);
    f= 20000;                                     % Frequency (Hz)
    f3= 20000;
    Fs= 199192;                                     % Sampling Frequency (Hz)
    t = linspace(0, len, Fs*len);                 % Time Vector
    infSignal=sin(2*pi*f*t);
    rpts=length(infSignal)/repeat;
    iSig=rpts/length(infor) %duração de 1 bit
    for l=1:repeat
        j=1;
        for z=1:rpts
            time=round(z+((l-1)*rpts),0);
            if infor(1,j)==0
                infSignal(1,time)=0;
            end
            if infor(1,j)==1
                infSignal(1,time)=1;
            end
            if j*iSig==z
               j=j+1;

            end
        end
        l=l+1;
    end
    signal = sin(2*pi*f*t);                         % Signal (10 kHz sine)
    signal3= sin(2*pi*f3*t);
    mxSignal=signal;%+signal2+signal3;
    for i=1:length(mxSignal)
        if infSignal(1,i)==0
            mxSignal(1,i)=signal3(1,i);

        else
            mxSignal(1,i)=signal(1,i);
        end

    end

    sound(mxSignal,Fs)
    %plot(mxSignal)

    %noise = signal + 0.1*randn(size(signal));
    %interpretaBits(mxSignal,f+100,f-100,iSig,length(infor),Fs,4)
end

function sinal_interpretado = interpretaBits(sinal_N_interpret,frequencia_corte_sup,frequencia_corte_inf,bit_dur,quantBits,Fs,valormult)
    hp=bandpass(sinal_N_interpret,[frequencia_corte_inf frequencia_corte_sup],Fs);
    mediaBits=zeros(1,quantBits);
    counter_bits=0;

    for i =1:length(sinal_N_interpret)
       if (i-(counter_bits*bit_dur))<=bit_dur-1
           mediaBits(1,counter_bits+1)=mediaBits(1,counter_bits+1)+abs(hp(1,i));

       else
           mediaBits(1,counter_bits+1)=mediaBits(1,counter_bits+1)+abs(hp(1,i));
           mediaBits(1,counter_bits+1)=mediaBits(1,counter_bits+1)/bit_dur
           floor(mediaBits(1,counter_bits+1))
           counter_bits=counter_bits+1;

       end
    end
    for i=1:quantBits
        if floor(mediaBits(1,i)*valormult)<=0
            mediaBits(1,i)=0;
        else
            mediaBits(1,i)=1;
        end
    end
    mediaBits
    subplot(1,2,1)
    plot(hp)
    subplot(1,2,2)
    plot(mediaBits)
end

