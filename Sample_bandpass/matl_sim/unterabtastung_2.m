% Skript unterabtastung_2.m, in dem eine Unterabtastung untersucht wird
% Arbeitet mit dem Simulink Modell unterabtastung2.slx
% Das Bandpasssignal wird aus dem unterabgetasteten Signal rekonstruiert

clear;
% ------- Initialisierungen
fsin = 39e3;              % Sinuseingangssignal 
fc = 40e3;                % Mittenfrequenz des Bandpasssignals
delta_f = 4e3;            % Bandbreite
fnoise = 1e6;             % Abtastfrequenz für den Band-Limited White
                          % Noise Block
fs = 18e3;                % NZ = 5;

% ------- Analogfilter für den Zufallsignal 
fmin = fc - delta_f/2;    % Untere Grenze des Frequenzbandes
fmax = fc + delta_f/2;    % Obere Grenze

nord = 6;
dp = 1;                   % Welligkeit im Durchlassbereich in dB
ds = 40;                  % Dämpfung im Sperrbereich in dB

[b,a] = ellip(nord, 1, ds,[fmin, fmax]*2*pi,'s');  % Elliptisches Filter 
% Frequenzgang
[H,w] = freqs(b,a);
figure(1),     clf;
plot(w/(2*pi), 20*log10(abs(H)),'k-','LineWidth',1);
title('Amplitudengang des Analogfilters');
xlabel('Hz');    ylabel('dB');     grid on;

% ------- Aufruf der Simulation
Tfinal = 1;
sim('unterabtastung2',[0,Tfinal]);
ys = y.Data;
t = y.Time;
ys1 = y1.Data;
t1 = y1.Time;

figure(2),    clf;
stairs(t, ys,'k-','LineWidth',1);
title('Signal nach dem Aufwärtstaster (Ausschnitt)');
xlabel('s');     grid on;
La = axis;   axis([0.44, 0.441, La(3:4)]);

% ------- Spektrale Leistungsdichte nach dem Aufwärtstaster
[Pyy,F] = pwelch(ys,hann(4096),[256],4096,fs*10);

figure(3),    clf;
plot(F, 10*log10(Pyy),'k-','LineWidth',1);
title('Spektrale Leistungsdichte des unterabgetasteten Signals über mehrere Perioden');
ylabel('dBW/Hz');      grid on;
xlabel(['Frequenz in Hz (fs = ',num2str(fs),' Hz)']);   
La = axis;    axis([0, max(F), La(3:4)]);

figure(4),    clf;
stairs(t1, y1.Data,'k-','LineWidth',1);
La = axis;   axis([0.44, 0.442, La(3:4)]);
title('Bandpasssignal und rekonstruiertes Bandpasssignal (Ausschnitt)');
xlabel('s');   grid on;


