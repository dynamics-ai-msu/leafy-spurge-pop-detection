function [labels,count,endMinute,endQuarSec] = manuallyLabelPops(inputAudio,startMinute,startQuarSec)

    % Load in audio and separate into different channels. The left channel
    % is always used in case the audio is mono or stereo.
    [audio,FS] = audioread(inputAudio);
    audioL = audio(:,1);
    clear audio;

    % 
    numMinutes = ceil(length(audioL)/60*FS);
    audioLabels = zeros(length(audioL),1);
    popCount = 0;

    endScript = 0;
    for minute = startMinute:numMinutes
        figure(1); clf;
        p1 = nexttile;
        spectrogram(audioL((minute*60*FS)+1:minute*60*FS+60*FS),hann(512),128,512,FS,'yaxis'); colorbar off; hold on;
        p1.YLim = [5 60];
        p2 = nexttile;
        p2.XGrid = 'on'; p2.XMinorGrid = 'on';
        t = 0:1/FS:(length(audioL((minute*60*FS):minute*60*FS+60*FS))-1)/FS;
        plot(t,audio((minute*60*FS):(minute*60*FS)+60*FS))

        for tenthSec = startQuarSec:999

            p1.XLim = [tenthSec*.1 (tenthSec+1)*.1];
            p2.XLim = [tenthSec*.1 (tenthSec+1)*.1];
            pause(.001);

            popFound = input("Is there a pop? (y or n): ","s");
            restart = 1;
            while(restart == 1)
                if(strcmpi(popFound, "y"))
                    popCount = popCount + 1;
                    startTime = input("Pop Start: ");
                    endTime = input("Pop End: ");
                    audioLabels(ceil(startTime*FS):ceil(endTime*FS)) = 1;
                        while(restart == 1)
                            popFound = input("Are there any more pops? (y or n): ","s");
                            if(strcmpi(popFound, "y"))
                                popCount = popCount + 1;
                                startTime = input("Pop Start: ");
                                endTime = input("Pop End: ");
                                audioLabels(ceil(startTime*FS):ceil(endTime*FS)) = 1;
                                popFound = input("Are there any more pops? (y or n): ","s");
                                restart = 0;
                            elseif(strcmpi(popFound,"n"))
                                restart = 0;
                            else
                                disp("Input must be y or n");
                                restart = 1;
                            end
                        end
                    restart = 0;
                elseif(strcmpi(popFound,"n"))
                    restart = 0;
                elseif(strcmpi(popFound,"end"))
                    endScript = 1;
                    endMinute = minute;
                    endQuarSec = tenthSec;
                    labels = audioLabels;
                    save(inputAudio + "-labels.mat","labels");
                    break
                else
                    disp("Input must be y or n");
                    restart = 1;
                end
            end
    
            if(endScript == 1)
                break
            end

        end

        if(endScript == 1)
            break
        end

    end


    labels = audioLabels;
    count = popCount;
    save(inputAudio + "-labels.mat","labels");

end