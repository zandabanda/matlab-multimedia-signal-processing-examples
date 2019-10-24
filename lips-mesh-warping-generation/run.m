function [output_imgs,mouthvideo] = run(AVdat_path, mouth_path, mesh_path)

rundir = pwd;

cd(AVdat_path); %cd ..;
copyfile('AV_Data.mat',rundir);
cd(rundir);

cd(mouth_path); %cd ..;
copyfile('mouth.jpg',rundir);
cd(rundir);

cd(mesh_path); %cd ..;
copyfile('mesh.txt',rundir);
cd(rundir);

neu_mouth = imread('mouth.jpg');
neu_mesh = dlmread('mesh.txt',' ');
neu_verty = neu_mesh(2:34,1);
neu_vertx = neu_mesh(2:34,2);
num_vert = length(neu_vertx);
neu_tri_vert = neu_mesh(36:77,:);
num_tri = length(neu_tri_vert); % constant
[neu_tri_coord] = tri_coord(neu_mesh, num_tri, neu_vertx, neu_verty);

AV_dat = load('AV_DATA.mat');

numN = 3; 
[mapping] = train(AV_dat.av_train, AV_dat.av_validate, AV_dat.silenceModel, numN, 'resultFile');
[test_Visuals] = test(AV_dat.testAudio, AV_dat.silenceModel, mapping);

output_imgs = warping(test_Visuals, neu_vertx, neu_verty, neu_mouth, neu_mesh, neu_tri_vert, neu_tri_coord, num_tri);

% Create JPEGS for all deformed images
%generateImages(output_imgs)

% Create m4v video file
%[mouthvideo] = generateVideo(output_imgs);


end


