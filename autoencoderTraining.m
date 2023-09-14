% Load in audio and grab left channel.
[audio,FS] = audioread("audio/200805_001.WAV");
FS = 192000;
audio = single(audio(:,1));

segmentedAudio = segmentAudio(audio,FS,.0025,.00125);

clear audio

%%

% Create wavelet scattering network and transform
waveletCoeffs = cell(1,size(segmentedAudio,2));
waveletNet = waveletScattering(SignalLength=.0025*FS,SamplingFrequency=FS, ...
                               QualityFactors=[4 1],OptimizePath=true);

    % Scattering transform
    parfor index = 1:numel(waveletCoeffs)
    
        waveletCoeffs{index} = waveletNet.featureMatrix(segmentedAudio{index});
    
    end

%%

clear segmentedAudio;

% Training sparse autoencoder?
hiddenSize = 25;
autoenc = trainAutoencoder(waveletCoeffs,hiddenSize, ...
                           EncoderTransferFunction='logsig', ...
                           DecoderTransferFunction='logsig', ...
                           SparsityProportion=.0005);

save("sparseAutoencoder.mat","autoenc");