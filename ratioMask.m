function ratio_mask = ratioMask(desired,interferer)

% Input:
%   1) desired - a magnitude spectrogram of the desired signal
%   2) interferer - a magnitude spectrogram of the interfering signal
%
% Output:
%   1) ratio_mask - a matrix containing ratio mask coefficients 

desired = abs(desired);
interferer = abs(interferer);

ratio_mask = desired./(desired + interferer + eps);


