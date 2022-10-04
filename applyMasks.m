function masked_TF = applyMasks(TF_mixture, masks)

% Inputs:
%   1) TF_mixture - a time-frequency representation of the mixture
%   2) masks - a mask for each source in the mixture, with dimensions
%       MxNxR:
%           M - number of frequency bins
%           N - mixture length
%           R - number of sources 
%
% Outputs:
%   1) masked_TF - all sources extracted from the mixture using the
%       corresponding masks, with dimensions MxNxR:
%           M - number of frequency bins
%           N - mixture length
%           R - number of sources 

[M, N, R] = size(masks);
masked_TF = zeros(M, N, R);
for r=1:R
    mask_r = masks(:,:,r); 
    masked_TF(:,:,r) = mask_r.*TF_mixture;
end