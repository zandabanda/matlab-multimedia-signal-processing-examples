function generateImages( output_imgs )

mkdir image_sequence; cd image_sequence; %dir = pwd; 

for img = 1:length(output_imgs)
    filename = strcat(num2str(img),'.jpg');
    imwrite(output_imgs{img,1},filename);
    %copyfile(jpg,dir);
end

cd ..
