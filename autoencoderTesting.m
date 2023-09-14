[audio,FS] = audioread("audio/200805_002.WAV");

audio = audio(:,1);

%%

splitAudio = buffer(audio,.0025*FS,.00125*FS,"nodelay");
testAudio = num2cell(splitAudio,1);

waveletCoeffs = cell(1,size(splitAudio,2));
waveletNet = waveletScattering(SignalLength=.0025*FS,SamplingFrequency=FS, ...
                               QualityFactors=[4 1],OptimizePath=true);

    % Scattering transform
    parfor index = 1:numel(waveletCoeffs)
    
        waveletCoeffs{index} = waveletNet.featureMatrix(testAudio{index});
    
    end
%%

load("sparseAutoencoder.mat");
testOutput = predict(autoenc,waveletCoeffs);

reconError = cell(1,size(testAudio,2));

parfor index = 1:numel(waveletCoeffs)
    reconError{index} = mse(waveletCoeffs{index} - testOutput{index});
end

%%
errorThreshold = 1.5e-3;
reconErrorMat = cell2mat(reconError);
% reconErrorMat(reconErrorMat < errorThreshold) = 0;

anomalyIndeces = find(reconErrorMat);
anomalyData = [testAudio{anomalyIndeces}];

% Good pop at testAudio{2054}