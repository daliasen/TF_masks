function[binary_mask] = binaryMask(desired,interferer)

% Inputs:
%   1) desired - a magnitude spectrogram of the desired signal
%   2) interferer - a magnitude spectrogram of the interfering signal
%
% Outputs:
%   1) binary_mask - a binary masks

binary_mask = double(desired > interferer); 