infor=[0,1,1,0,1,1,0,1];
repeat=1;
length(infor);
len = 3;                                       % Length (sec)
f= 18000;                                     % Frequency (Hz)
f2= 20000;
f3= 22000;
Fs= 199192;                                     % Sampling Frequency (Hz)
t = linspace(0, len, Fs*len);                 % Time Vector
infSignal=sin(2*pi*f*t);
lInfSig=length(infSignal);
i=1;
k=1;
m=1;
tt=length(infSignal)/(repeat*length(infor)); 
rpts=length(infSignal)/repeat;
iSig=rpts/length(infor) %duração de 1 bit
chave=0;

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
signal2= sin(2*pi*f2*t);
signal3= sin(2*pi*f3*t);
lp=lowpass(signal,f*1.05,Fs);
hp=highpass(lp,f*0.95,Fs);
lp2=lowpass(signal2,f2*1.05,Fs);
hp2=highpass(lp2,f2*0.95,Fs);
lp3=lowpass(signal3,f3*1.05,Fs);
hp3=highpass(lp3,f3*0.95,Fs);
signal=hp;
signal2=hp2;
signal3=hp3; 
%mxSignal=signal+signal2+signal3;
lp4=lowpass(mxSignal,23500,Fs);
hp4=highpass(lp4,17000,Fs);
%mxSignal=hp4*infSignal;
i=1;
for i=1:length(mxSignal)
    if infSignal(1,i)==0
        mxSignal(1,i)=signal3(1,i);
        
    else
        mxSignal(1,i)=signal(1,i);
    end
        
end
lpf=lowpass(mxSignal,f3+500,Fs);
hpf=highpass(lpf,f-500,Fs);
mxSignal=hpf;
sound(mxSignal,Fs)
plot(mxSignal)

%noise = signal + 0.1*randn(size(signal));

interpretaBits(mxSignal,18500,17500,iSig,length(infor),Fs)

function sinal_interpretado = interpretaBits(sinal_N_interpret,frequencia_corte_sup,frequencia_corte_inf,bit_dur,quantBits,Fs)

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
    if floor(mediaBits(1,i)*100)<=0
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