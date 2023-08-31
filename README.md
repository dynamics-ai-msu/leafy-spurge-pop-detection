# leafy-spurge-pop-detection

autoencoderTesting.m : Calculating the feature matrix for the wavelet scattering on the testing data and test trained autoencoder on it.
autoencoderTraining.m : Train autoencoder on wavelet scattering feature matrix from input audio (either pop audio or other wind audio).
generateExampleFigures.m : Creates variety of figures for presentations
manuallyLabelPops.m : Allows user to input audio file and manually label the pops over small interval times with the time domain and spectrogram showing.
segmentAudio.m : Function for splitting audio with overlap, essentially just the buffer function with a simpler interface.
sparseAutoencoder*.mat : Trained autoencoder

the audio folder contains audio and labels.