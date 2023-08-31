[inputAudio,FS] = audioread("audio/200805_002.WAV");
audio = inputAudio(:,1);
load("audio/200805_002.WAV-labels.mat");
waveletNet = waveletScattering(SignalLength=.0025*FS,SamplingFrequency=FS, ...
                               QualityFactors=[4 1],InvarianceScale=.0005, ...
                               OptimizePath=true);
%% Audio and Spectrograms
fig1 = figure(1); 
t1 = tiledlayout(fig1,2,3);
% 1m Audio
p1 = nexttile;
plot(audio(137320000:148840000)); title("Audio (1m)");
% 1s Audio
p2 = nexttile;
plot(audio(140200000:140392000)); title("Audio (1s)");
% Pop Audio
p3 = nexttile;
plot(audio(140301064:140309119)); title("Pop Audio");
xlim([0 8054]);
% 1m Audio Spectrogram
p4 = nexttile;
spectrogram(audio(137320000:148840000),hann(512),128,512,FS,'yaxis'); colorbar off; title("Audio (1m) Spectrogram");
% 1s Audio Spectrogram
p5 = nexttile;
spectrogram(audio(140200000:140392000),hann(512),128,512,FS,'yaxis'); colorbar off; title("Audio (1s) Spectrogram");
% Pop Spectrogram
p6 = nexttile;
spectrogram(audio(140293972:140310356),hann(512),128,512,FS,'yaxis'); colorbar off; title("Pop Spectrogram");

exportgraphics(fig1,"AudioSpectrogramsExamples.pdf","ContentType","vector");

%% Wavelet Scattering Example
fig2 = figure(2);
t2 = tiledlayout(fig2,3,2);
% 1s Audio
p1 = nexttile;
plot(audio(140301674:140302154)); title("Audio");
xlim([0 480]);
% Pop Audio
p2 = nexttile;
plot(audio(140302064:140302544)); title("Pop Audio");
xlim([0 480]);
% 1s Audio Scattergram Scattering Coefficients
p3 = nexttile;
[S,U] = scatteringTransform(waveletNet,audio(140301674:140302153));
img = scattergram(waveletNet,S);
imagesc(img); title("Audio Scattering Coefficients");
% Pop Scattergram Scattering Coefficients
p4 = nexttile;
[S,U] = scatteringTransform(waveletNet,audio(140302064:140302543));
img = scattergram(waveletNet,S);
imagesc(img); title("Pop Scattering Coefficients");
% 1s Audio Scattergram Scalogram Coefficients
p5 = nexttile;
[S,U] = scatteringTransform(waveletNet,audio(140301674:140302153));
img = scattergram(waveletNet,U);
imagesc(img); title("Audio Scalogram Coefficients");
% Pop Scattergram Scalogram Coefficients
p6 = nexttile;
[S,U] = scatteringTransform(waveletNet,audio(140302064:140302543));
img = scattergram(waveletNet,U);
imagesc(img); title("Pop Scalogram Coefficients");

exportgraphics(fig2,"ScatteringTransformExamples.pdf","ContentType","vector");

%% CWT Future Work
fig3 = figure(3);
cwt(audio(140293972:140310356)); title("Pop CWT");
exportgraphics(fig3, "PopCWTExample.pdf","ContentType","vector");

fig4 = figure(4);
cwt(audio(1:16384)); title("Regular Audio CWT");
exportgraphics(fig4,"AudioCWTExample.pdf","ContentType","vector");

fig5 = figure(5);
cwt(audio(47421700:47438084)); title("Clipping CWT");
exportgraphics(fig5,"ClippingCWTExample.pdf","ContentType","vector");
