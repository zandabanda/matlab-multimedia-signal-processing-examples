function [ audio_visual_2, audio_visual_5, audio_2, audio_2_instance, audio_5, audio_5_instance, video_2, video_2_instance, video_5, video_5_instance ] = load_feat( data_path )

main_dir = pwd;
cd(data_path);
files = dir(pwd);

audio_2 = cell(1,length(files));
audio_2_instance = cell(1,length(files));
audio_5 = cell(1,length(files));
audio_5_instance = cell(1,length(files));

video_2 = cell(1,length(files));
video_2_instance = cell(1,length(files));
video_5 = cell(1,length(files));
video_5_instance = cell(1,length(files));

    for file=1:length(files)
        if (files(file).isdir == 0 && ~strcmp('README',files(file).name))
            
            [seg1,rem1] = strtok(files(file).name,'.');
            [seg2,rem2] = strtok(rem1,'.');
            seg3 = strtok(rem2,'.');
            
            if (strcmp(seg1,'2') && strcmp(seg3,'a'))
                audio_2{file} = load(files(file).name);
                audio_2_instance{file} = seg2;
            elseif (strcmp(seg1,'2') && strcmp(seg3,'v'))
                video_2{file} = load(files(file).name);
                video_2_instance{file} = seg2;
            elseif (strcmp(seg1,'5') && strcmp(seg3,'a'))
                audio_5{file} = load(files(file).name);
                audio_5_instance{file} = seg2;
            elseif (strcmp(seg1,'5') && strcmp(seg3,'v'))
                video_5{file} = load(files(file).name);
                video_5_instance{file} = seg2;
            end
            
            
            %features{file} = load(files(file).name);
            %features = features(~cellfun('isempty',features));
            %digit{file} = seg1;
            %digit = digit(~cellfun('isempty',digit));
            %instance{file} = seg2;
            %instance = instance(~cellfun('isempty',instance));
            %type{file} = seg3;
            %type = type(~cellfun('isempty',type));
            
        end
    end
    
    audio_2 = audio_2(~cellfun('isempty',audio_2));
    audio_2_instance = audio_2_instance(~cellfun('isempty',audio_2_instance));
    audio_5 = audio_5(~cellfun('isempty',audio_5));
    audio_5_instance = audio_5_instance(~cellfun('isempty',audio_5_instance));
    video_2 = video_2(~cellfun('isempty',video_2));
    video_2_instance = video_2_instance(~cellfun('isempty',video_2_instance));
    video_5 = video_5(~cellfun('isempty',video_5));
    video_5_instance = video_5_instance(~cellfun('isempty',video_5_instance));  
    
    
    audio_visual_2 = cell(1,10);
    audio_visual_5 = cell(1,10);
    
    for inst = 1:length(audio_2)
        audio_visual_2{inst} = cat(2,audio_2{inst},video_2{inst});
        audio_visual_5{inst} = cat(2,audio_5{inst},video_5{inst});
    end
   
    

cd(main_dir);

end

