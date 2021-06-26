% Script subsampling_1.m in which a subsampling is examined
% Works with the Simulink model subsampling1.slx
clear;
% ------- Initializations
fsin = 39e3;              % Sine input signal 
fc = 40e3;                % Center frequency of the bandpass signal
delta_f = 4e3;            % Bandwidth
fnoise = 1e6;             % Sampling frequency for the 'Band-Limited White
                      % Noise' block
fs = 18e3;                % NZ = 5;
%fs = 15e3;               % NZ = 6;            
%fs = 14.5455e3;          % NZ = 6;
%fs = 17.777e3;           % NZ = 5;

% ------- Analog filter for the random signal
fmin = fc - delta_f/2;    % Lower limit of the frequency band
fmax = fc + delta_f/2;    % Upper limit

nord = 6;
dp = 1;                   % Ripple in the passband in dB
ds = 40;                  % Attenuation in the stop band in dB

[b,a] = ellip(nord, 1, ds,[fmin, fmax]*2*pi,'s');  % Elliptical filter
% Frequency response
[H,w] = freqs(b,a);
figure(1),     clf;
plot(w/(2*pi), 20*log10(abs(H)),'k-','LineWidth',1);
title('Amplitude response of the analog filter');
xlabel('Hz');    ylabel('dB');     grid on;

% ------- Calling the simulation
Tfinal = 0.5;
sim('subsampling1',[0,Tfinal]);
ys = y.Data;
t = y.Time;

figure(2),    clf;
stairs(t, ys,'k-','LineWidth',1);
title('Signal after the ''Upsample'' block (excerpt)');
xlabel('s');     grid on;
La = axis;   axis([0.44, 0.441, La(3:4)]);

% ------- Power spectral density after the upsample
[Pyy,F] = pwelch(ys,hann(4096),[256],4096,fs*10);

figure(3),    clf;
plot(F, 10*log10(Pyy),'k-','LineWidth',1);
title(['Power spectral density of the subsampled signal'...
    ' over several periods']);
ylabel('dBW/Hz');      grid on;
xlabel(['Frequency in Hz (fs = ',num2str(fs),' Hz)']);   
La = axis;    axis([0, max(F), La(3:4)]);




