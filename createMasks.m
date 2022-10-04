function[masks] = createMasks(est_sources, maskParams)

% Input:
%   1) est_sources - magnitude spectrograms of the estimated sources, with 
%       dimensions MxNxR:
%           M - frequency bins
%           N - mixture length
%           R - sources i.e. bases
%   2) maskParams - mask parameters:
%       maskParams.type - mask name (binary-max, binary-sum, ratio, 
%           combined, sigmoid)
%       maskParams.p - power for a sigmoid mask
%       maskParams.zeta - balance between a ratio and a binary masks for 
%           a combined mask
%
% Output:
%   1) masks - a tensor containing masks for all sources

maskType = maskParams.type;

if strcmp(maskType, 'combined') || strcmp(maskType, 'binary')
    switch maskType
        case 'binary'        
        masks = binaryMasksMax(est_sources);      
    case 'combined'
        masks = combinedMasks(est_sources, maskParams.zeta);
    end
else
    [M, N, R] = size(est_sources); 
    masks = zeros(M, N, R);
    all_source_indeces = linspace(1, R, R);
    for r=1:R
        desired = est_sources(:,:,r);
        
        % everything else
        interferer_indeces = all_source_indeces(1:end ~= r);
        interferers = est_sources(:,:,interferer_indeces);
        interferer = sum(interferers, 3);
        
        switch maskType
        case 'ratio'
            masks(:,:,r) = ratioMask(desired,interferer);
        case 'sigmoid'
            masks(:,:,r) = sigmoidMask(desired,est_sources,maskParams.p);        
        otherwise
            error('mask must be binary, ratio, combined, or sigmoid');
        end
    end
end