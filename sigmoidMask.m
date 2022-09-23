function[sigmoid_mask] = sigmoidMask(desired,all_sources,p)

% Inputs:
%   1) desired - a magnitude spectrogram of the desired signal
%   2) all_sources - magnitude spectrograms of all signals including the
%       desired, with dimensions RxMxN:
%           R - number of sources 
%           M - number of frequency bins
%           N - mixture length
%   3) p - power
%
% Outputs:
%   4) sigmoid_mask - a sigmoid mask (aka logit)

sigmoid_mask = desired.^p./(permute(sum(all_sources.^p,1), [2 3 1]) + eps);