% Skript unterabtastung_1.m, in dem eine Unterabtastung untersucht wird
% Arbeitet mit dem Simulink Modell unterabtastung1.slx

clear;
% ------- Initialisierungen
fsin = 39e3;              % Sinuseingangssignal 
fc = 40e3;                % Mittenfrequenz des Bandpasssignals
delta_f = 4e3;            % Bandbreite
fnoise = 1e6;             % Abtastfrequenz f�r den Band-Limited White
                          % Noise Block
fs = 18e3;                % NZ = 5;
%fs = 15e3;               % NZ = 6;            
%fs = 14.5455e3;          % NZ = 6;
%fs = 17.777e3;           % NZ = 5;

% ------- Analogfilter f�r den Zufallsignal 
fmin = fc - delta_f/2;    % Untere Grenze des Frequenzbandes
fmax = fc + delta_f/2;    % Obere Grenze

nord = 6;
dp = 1;                   % Welligkeit im Durchlassbereich in dB
ds = 40;                  % D�mpfung im Sperrbereich in dB

[b,a] = ellip(nord, 1, ds,[fmin, fmax]*2*pi,'s');  % Elliptisches Filter 
% Frequenzgang
[H,w] = freqs(b,a);
figure(1),     clf;
plot(w/(2*pi), 20*log10(abs(H)),'k-','LineWidth',1);
title('Amplitudengang des Analogfilters');
xlabel('Hz');    ylabel('dB');     grid on;

% ------- Aufruf der Simulation
Tfinal = 1;
sim('unterabtastung1',[0,Tfinal]);
ys = y.Data;
t = y.Time;

figure(2),    clf;
stairs(t, ys,'k-','LineWidth',1);
title('Signal nach dem Aufw�rtstaster (Ausschnitt)');
xlabel('s');     grid on;
La = axis;   axis([0.44, 0.441, La(3:4)]);

% ------- Spektrale Leistungsdichte nach dem Aufw�rtstaster
[Pyy,F] = pwelch(ys,hann(4096),[256],4096,fs*10);

figure(3),    clf;
plot(F, 10*log10(Pyy),'k-','LineWidth',1);
title('Spektrale Leistungsdichte des unterabgetasteten Signals �ber mehrere Perioden');
ylabel('dBW/Hz');      grid on;
xlabel(['Frequenz in Hz (fs = ',num2str(fs),' Hz)']);   
La = axis;    axis([0, max(F), La(3:4)]);




