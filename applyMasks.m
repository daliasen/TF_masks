function masked_TF = applyMasks(mixture_TF, masks)

% Inputs:
%   1) mixture_TF - a time-frequency representation of the mixture
%   2) masks - a mask for each source in the mixture
%
% Outputs:
%   1) masked_TF - all sources extracted from the mixture using the
%       corresponding masks

[R,M,N] = size(masks);
masked_TF = zeros(R,M,N);
for r=0:R-1
    mask_r = permute(masks(r+1,:,:), [2 3 1]); 
    masked_TF(r+1,:,:) = mask_r.*mixture_TF;
end