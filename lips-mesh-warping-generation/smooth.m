% function [output] = smooth(input)
%
% This function use three consecutive frames to smooth the results.
% Each column of input is an input vector.

function [output] = smooth(input)

[v,h] = size ( input );
output = input;

output ( :, 2:h-1) = ( output(:, 1:h-2) + output(:, 2:h-1) + output(:, 3:h) ) / 3;

   
  