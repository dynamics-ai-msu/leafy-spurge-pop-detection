% Load in audio and grab left channel.
[audio,FS] = audioread("audio/howling-wind-14892.mp3");
FS = 192000;
audio = single(audio(:,1));

segmentedAudio = segmentAudio(audio,FS,.0025,.00125);

clear audio

%%

% Create wavelet scattering network and transform
waveletCoeffs = cell(1,size(segmentedAudio,2));
waveletNet = waveletScattering(SignalLength=.0025*FS,SamplingFrequency=FS, ...
                               QualityFactors=[4 1],InvarianceScale=.0005, ...
                               OptimizePath=true);

    % Scattering transform
    parfor index = 1:numel(waveletCoeffs)
    
        waveletCoeffs{index} = waveletNet.featureMatrix(segmentedAudio{index});
    
    end

%%

clear segmentedAudio;

% Training sparse autoencoder?
hiddenSize = 50;
autoenc = trainAutoencoder(waveletCoeffs,hiddenSize, ...
                           EncoderTransferFunction='satlin', ...
                           DecoderTransferFunction='purelin');

save("sparseAutoencoder.mat","autoenc");