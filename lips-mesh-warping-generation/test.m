% Copyright: Pengyu Hong {hong@ifp.uiuc.edu}
%
% function [results] = test ( testAudio, silenceModel, mapping )
%
% This function estimates the visual features for the test audio data.
%
%   testAudio is the test audio data. Each column is a data item.
%
%   silenceModel is used to decide if an audio frame is a silence segement based on the audio features.
%
%   mapping is the trained neural network as the audio-visual mapping.

function [results] = test ( testAudio, silenceModel, mapping )

results = [];

[adim, num] = size ( testAudio );
vdim = length ( mapping.nets );

results = zeros ( vdim, num );
for k = 1 : num
    if ( testAudio(1, k) < silenceModel(1) ) | ( testAudio(2, k) < silenceModel(2) )
        results(:, k) = 0;
    else
        for m = 1 : vdim
            results(m, k) = sim ( mapping.nets(m).net, testAudio(:, k) );
        end
    end
end

% This step use a simple method to smooth out the jerky results.
results = smooth ( results );