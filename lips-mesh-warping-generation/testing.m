%% Testing

%% Run entire process (run.m)
[output_img,~] = run('~/path/to/data', '~/path/to/data', '~/path/to/data');
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
%% Linearly Interpolate neutral mesh over Training Model
%fScale = 1; % experiment
%[retVertX_omin, retVertY_omin] = interpVert(neu_vertx, neu_verty, 0, 0, 0, mapping.nets(1).omin, mapping.nets(2).omin, mapping.nets(3).omin, fScale);
%[retVertX_omax, retVertY_omax] = interpVert(neu_vertx, neu_verty, 0, 0, 0, mapping.nets(1).omax, mapping.nets(2).omax, mapping.nets(3).omin, fScale);
%% Generate Visual Features from Test Audio
% user NN to find visual features for 456 frames of test data
[test_Visuals] = test(AV_dat.testAudio, AV_dat.silenceModel, mapping);
%% Image Deformation
% deform a particular image, set by frame
frame = 173;
[output_img] = warping_sing(frame, test_Visuals, neu_vertx, neu_verty, neu_mouth, neu_mesh, neu_tri_coord, num_tri);
imshow(output_img);
%% Generate all deformed images
%iterate through each frame, for each one, apply warping function.
[output_imgs] = warping(test_Visuals, neu_vertx, neu_verty, neu_mouth, neu_mesh, neu_tri_vert, neu_tri_coord, num_tri);
%% Create JPEGS for all deformed images
generateImages(output_imgs)
%% Create m4v video file
[v] = generateVideo(output_imgs);
%%
for img = 30:60
    figure;
    imshow(output_imgs{img,1})
end

%%
%size_mouth = size(neu_mouth);
fScale = 1;

%output_img = uint8(zeros(size_mouth(1),size_mouth(2)));

[new_vertx,new_verty] = interpVert(neu_vertx, neu_verty, 0, 0, 0, test_Visuals(1,257), test_Visuals(2,257), test_Visuals(3,257), fScale);
[new_tri_coord] = tri_coord(neu_mesh,num_tri,new_vertx,new_verty);
    
%%
T = [[neu_tri_coord{21,1}, 1]',[neu_tri_coord{21,2}, 1]',[neu_tri_coord{21,3}, 1]'];
x = [72; 83; 1]; % image vector
                
lamb = T\x;
lambi = inv(T)*x;
lambp = pinv(T)*x;

x_new = [new_tri_coord{1,1}',new_tri_coord{1,2}',new_tri_coord{1,3}']*lamb;
x_new_NN = [floor(x_new(1)+.5),floor(x_new(2)+.5)];
%%
output_img(x_new_NN(1),x_new_NN(2)) = neu_mouth(row,col);
