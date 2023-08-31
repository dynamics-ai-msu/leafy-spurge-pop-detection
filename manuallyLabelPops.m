function [labels,count,endMinute,endTenth] = manuallyLabelPops(inputAudio,startMinute,startTenth)

    % Load in audio and separate into different channels. The left channel
    % is always used in case the audio is mono or stereo.
    [audio,FS] = audioread(inputAudio);
    audioL = audio(:,1);
    clear audio;

    % If the labels already exists, loads in the labels so that you don't
    % have to label it all in one go that would be miserable good lord.
    if(isfile(inputAudio + "-labels.mat"))
        load(inputAudio + "-labels.mat");
    else
        labels = zeros(length(audioL),1);
    end

    % Determines number of minutes in the input audio file.
    numMinutes = ceil(length(audioL)/60/FS);
    difference = numMinutes*60*FS - length(audioL);
    audioL = [audioL ; zeros(difference,1)];
    popCount = 0;

    endScript = 0;

    % Generates spectrogram for the minute segment
    for minute = startMinute:numMinutes
        fig1 = figure(1); clf;
        t1 = tiledlayout(2,1,"TileSpacing","compact","Padding","tight"); hold on;
        p1 = nexttile;
        spectrogram(audioL((minute*60*FS)+1:minute*60*FS+60*FS),hann(512),128,512,FS,'yaxis'); colorbar off; hold on;
        p1.YLim = [5 60];
        p2 = nexttile;
        p2.XGrid = 'on'; p2.XMinorGrid = 'on';
        p2.YLim = [-1 1];
        t = 0:1/FS:60;
        plot(t',audioL(minute*60*FS : minute*60*FS + 60*FS));
        linkaxes([p1 p2],'x');
        pause(.001);

        % Scrolls through a tenth of a second at a time, which is pretty
        % much the largest the frame can be and still have the pops be
        % visible.
        for tenthSec = startTenth:240

            p1.XLim = [tenthSec*.25 (tenthSec+1)*.25];
            p2.XLim = [tenthSec*.25 (tenthSec+1)*.25];
            p2.YLimMode = "auto";
            pause(.001);

            restart = 1;
            while(restart == 1)
                popFound = input("Is there a pop? [ y | n | relabel | end ]: ","s");
                if(strcmpi(popFound, "y"))
                    popCount = popCount + 1;
                    startTime = input("Pop Start: ");
                    endTime = input("Pop End: ");
                    labels(ceil(minute*60*FS + startTime*FS):ceil(minute*60*FS + endTime*FS)) = 1;
                        while(restart == 1)
                            popFound = input("Are there any more pops? (y or n): ","s");
                            if(strcmpi(popFound, "y"))
                                popCount = popCount + 1;
                                startTime = input("Pop Start: ");
                                endTime = input("Pop End: ");
                                labels(ceil(minute*60*FS + startTime*FS):ceil(minute*60*FS + endTime*FS)) = 1;
                                restart = 1;
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
                    endTenth = tenthSec;
                    labels = labels;
                    save(inputAudio + "-labels.mat","labels");
                    break
                elseif(strcmpi(popFound,"relabel"))
                    disp("Clearing labels for frame");
                    labels(ceil(minute*60*FS + tenthSec*.25*FS):ceil(minute*60*FS + (tenthSec+1)*.25*FS)) = 0;
                    restart = 1;
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


    labels = labels;
    count = popCount;
    save(inputAudio + "-labels.mat","labels");

end