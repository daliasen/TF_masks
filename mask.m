function masked_TF = mask(est_sources, mixture_TF, maskParams)

% Inputs:
%   1) est_sources - magnitude spectrograms of the estimated sources, with 
%       dimensions RxMxN:
%           M - frequency bins
%           R - sources i.e. bases
%           N - mixture length
%   2) mixture_TF - a time-frequency representation of the mixture
%   3) maskParams - time-frequency mask parameters:
%       maskParams.type - mask name (binary-max, binary-sum, ratio, 
%           combined or sigmoid)
%       maskParams.p - power for the sigmoid mask
%       maskParams.zeta - balance between the ratio and the binary masks for 
%           the combined mask
%
% Outputs:
%   1) masked_TF - all sources extracted from the mixture using the
%       corresponding masks (a single type of mask specified in maskParams)

masks = createMasks(est_sources,maskParams); 
masked_TF = applyMasks(mixture_TF,masks); 