%% Run entire process (run.m)
[output_imgs,~] = run('~/path/to/av_data', '~/path/to/mouth', '~/path/to/mesh');
% replace these paths with 'AVdat_path', 'mouth_path', and 'mesh_path'
% respectively, the subdirectories containing those files.
%% Load Data
neu_mouth = imread('mouth.jpg');
% read neutral image
neu_mesh = dlmread('mesh.txt',' ');
% row1 = # vertices, row2-34 = vertex coordinates, row35 =  # triangles, row36-77 = triangle indices

neu_verty = neu_mesh(2:34,1);
neu_vertx = neu_mesh(2:34,2);

num_vert = length(neu_vertx);
neu_tri_vert = neu_mesh(36:77,:);
num_tri = length(neu_tri_vert); % constant
[neu_tri_coord] = tri_coord(neu_mesh, num_tri, neu_vertx, neu_verty);

% load training data
AV_dat = load('AV_DATA.mat');
% 3 layer model
numN = 3; 
%% Train Neural Network
% train neural network, for w, h1, and h2 (3 total)
[mapping] = train(AV_dat.av_train, AV_dat.av_validate, AV_dat.silenceModel, numN, 'resultFile');
%% Generate Visual Features from Test Audio
% user NN to find visual features for 456 frames of test data
[test_Visuals] = test(AV_dat.testAudio, AV_dat.silenceModel, mapping);
%% Image Deformation
%% Generate all deformed images
%iterate through each frame, for each one, apply warping function.
[output_imgs] = warping(test_Visuals, neu_vertx, neu_verty, neu_mouth, neu_mesh, neu_tri_vert, neu_tri_coord, num_tri);
%% Create JPEGS for all deformed images
generateImages(output_imgs)
%% Create m4v video file
[mouthvideo] = generateVideo(output_imgs);
