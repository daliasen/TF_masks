function [binary_mask_1, binary_mask_2] = binaryMask(source_1, source_2)
% Compute masks for extracting sources from a mixture of two sources.
%
% Inputs:
%   1) source_1 - a magnitude spectrogram of the first source, MxN
%   2) source_2 - a magnitude spectrogram of the the second source, MxN
%
% Outputs:
%   1) binary_mask_1 - a binary mask for extracting source_1, MxN
%   2) binary_mask_2 - a binary mask for extracting source_2, MxN

binary_mask_1 = double(source_1 > source_2);
binary_mask_2 = double(source_2 >= source_1);
