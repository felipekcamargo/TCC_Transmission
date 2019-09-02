infor=[1];
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
iSig=rpts/length(infor)
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
mxSignal=signal+signal2+signal3;
lp4=lowpass(mxSignal,23500,Fs);
hp4=highpass(lp4,17000,Fs);
%mxSignal=hp4*infSignal;
i=1;
for i=1:length(mxSignal)
    if infSignal(1,i)==0
        mxSignal(1,i)=0;
        
    else
        mxSignal(1,i)=hp4(1,i);
    end
        
end
lpf=lowpass(mxSignal,f3+500,Fs);
hpf=highpass(lpf,f-500,Fs);
mxSignal=hpf;
%sound(signal,Fs)                               % Original Signal
%sound(signal2,Fs)                               % Original Signal
%sound(signal3,Fs)                               % Original Signal
sound(mxSignal,Fs)
%plot(mxSignal)
plot(mxSignal)
%noise = signal + 0.1*randn(size(signal));

%pause(3)                                       % Wait For First Sound To Finish Playing
%sound(noise, Fs)
%bandpass(signal,[20500 21500],Fs)
%sound(signal)