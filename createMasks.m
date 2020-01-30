function masks = createMasks(est_sources, maskParams)

% Input:
%   1) est_sources - magnitude spectrograms of the estimated sources, with 
%       dimensions RxMxN:
%           M - frequency bins
%           R - sources i.e. bases
%           N - mixture length
%   2) maskParams - time-frequency mask parameters:
%       maskParams.type - mask name (binary-max, binary-sum, ratio, 
%           combined, sigmoid)
%       maskParams.p - power for the sigmoid mask
%       maskParams.zeta - balance between the ratio and the binary masks for 
%           the combined mask
%
% Output:
%   1) masks - a tensor containing masks for all sources

maskType = maskParams.type;

[R,M,N] = size(est_sources); 
masks = zeros(R,M,N);
for r=0:R-1
    desired = permute(est_sources(r+1,:,:), [2 3 1]);
    
    interferer = zeros(M,N);
    for r_inner=0:R-1
        if r_inner ~= r
            interferer = interferer + permute(est_sources(r_inner+1,:,:), [2 3 1]); % everything else
        end
    end
   
    switch maskType
    case 'binary-max'
        interferers = permute(est_sources(1:end ~= r+1,:,:), [2 3 1]);
%         if r<R-1
        masks(r+1,:,:) = desired > max(interferers,[],3);
%         else
%             masks(r+1,:,:) = desired >= max(interferers,[],3);
%         end
    case 'binary-sum'
        masks(r+1,:,:) = desired > interferer;
    case 'ratio'
        masks(r+1,:,:) = ratioMask(desired,interferer);        
    case 'combined'
        masks(r+1,:,:) = combinedMask(desired,interferer,maskParams.zeta);        
    case 'sigmoid'
        masks(r+1,:,:) = sigmoidMask(desired,est_sources,maskParams.p);        
    otherwise
        error('mask must be binary, relative, combined or sigmoid');
    end
end