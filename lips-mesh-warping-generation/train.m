% Copyright: Pengyu Hong {hong@ifp.uiuc.edu}.
%
% function [mapping] = train ( avTrainingData, avValidateData, silenceModel, numN, resultFile )
%
% This function trains and returns a three-layer neural network as the audio-visual mapping.
%
%   avTrainingData is the training data. 
%      avTrainingData.audio is the audio data. Each column is a data item
%      avTrainingData.visual is the visual data. Each column is a data item
%
%   avValidateData is used for validation which prevents training a neural networks overfitting the training data.
%      avValidateData.audio is the audio data. Each column is a data item
%      avValidateData.visual is the visual data. Each column is a data item
%
%   silenceModel is used to decide if an audio frame is a silence segement based on the first two audio features.
%
%   numN is the number of hidden neurons.
%
%   resultFile is the name of the file where the trained neural network will be store.

function [mapping] = train ( avTrainingData, avValidateData, silenceModel, numN, resultFile )

% Get rid of the data corresponding to silence. 
avTrainingData = clean_silence ( avTrainingData, silenceModel );
avValidateData = clean_silence ( avValidateData, silenceModel );

% Get the dimensions
adim = size ( avTrainingData.audio, 1 );
vdim = size ( avTrainingData.visual, 1 );

PR (:, 1) = min ( avTrainingData.audio, [], 2 );
PR (:, 2) = max ( avTrainingData.audio, [], 2 );
VV.P = avValidateData.audio;

% Train one neural network for each visual dimension.
for m = 1 : vdim
   sprintf( 'dimension %d', m )
   output = avTrainingData.visual(m,:);
   %mapping.nets(m).net = newff (PR, [numN, 1], {'tansig' 'purelin'});
   mapping.nets(m).net = newff (avTrainingData.audio, output, numN);
   mapping.nets(m).net.trainParam.show = 5;
   mapping.nets(m).net.trainParam.epochs = 100;
   mapping.nets(m).omin = min(output);
   mapping.nets(m).omax = max(output);
   tt = max ( abs(mapping.nets(m).omin), abs(mapping.nets(m).omax) ) * 0.05;
   mapping.nets(m).net.trainParam.goal = tt * tt;
       
   VV.T = avValidateData.visual(m,:);
   %mapping.nets(m).net = train(mapping.nets(m).net, avTrainingData.audio, output, [], [], VV, []);
   mapping.nets(m).net = train(mapping.nets(m).net, avTrainingData.audio, output, [], [], VV);
end

% Save the results into the resultFile.
if nargin > 4
   save (resultFile, 'mapping');
end

