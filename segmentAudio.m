function segmentedAudio = segmentAudio(audio,FS,frameLength,frameOverlap)

    segmentedAudio = num2cell(buffer(audio,frameLength*FS,frameOverlap*FS,"nodelay"),1);

end