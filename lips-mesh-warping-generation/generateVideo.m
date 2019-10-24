function [ video ] = generateVideo( output_imgs )

video = VideoWriter('mouthvideo.m4v','MPEG-4');
video.FrameRate = 30;
video.Quality = 100;
open(video)
for i = 1:length(output_imgs)
            img = output_imgs{i,1};
            img = img/max(img(:));
            writeVideo(video,img);
end
close(video)

end

