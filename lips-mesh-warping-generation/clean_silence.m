% Copyright: Pengyu Hong {hong@ifp.uiuc.edu}
%
% function [result] = clean_silence ( data, silenceModel )
%
% This function delete all the audio-visual feature data items that corresponding to silence.
%
%   data is the original audio-visual data set.
%
%   silenceModel is used to decide if an audio frame is a silence frame.

function [result] = clean_silence ( data, silenceModel )

len = length ( data.audio );

result.audio = [];
result.visual = [];
for k = 1 : len
    if ( data.audio(1, k) > silenceModel(1) ) & ( data.audio(2, k) > silenceModel(2) )
        result.audio = [result.audio, data.audio(:,k)];
        result.visual = [result.visual, data.visual(:,k)];
    end    
end