function[masked_TF] = applyMasks(TF_mixture,masks)

% Inputs:
%   1) TF_mixture - a time-frequency representation of the mixture
%   2) masks - a mask for each source in the mixture
%
% Outputs:
%   1) masked_TF - all sources extracted from the mixture using the
%       corresponding masks

[R,M,N] = size(masks);
masked_TF = zeros(R,M,N);
for r=0:R-1
    mask_r = permute(masks(r+1,:,:), [2 3 1]); 
    masked_TF(r+1,:,:) = mask_r.*TF_mixture;
end