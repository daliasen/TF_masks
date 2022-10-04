function masks = binaryMasksMax(all_sources)

% Compute binary masks for any number of sources.
%
% Inputs:
%   1) all_sources - magnitude spectrograms of all sources,
%       with dimentions MxNxR:
%           M - frequency bins
%           N - mixture length
%           R - sources
%
% Outputs:
%   1) masks - binary masks

[M, N, R] = size(all_sources);
masks = zeros(M, N, R);
all_source_indeces = linspace(1, R, R);
for r=1:R    
    desired = all_sources(:,:,r);
    
    interferer_indeces = all_source_indeces(1:end ~= r);
    interferers = all_sources(:,:,interferer_indeces);
    
    masks(:,:,r) = desired >= max(interferers, [], 3);
end

% remove duplicate ones
summed = sum(masks, 3);
r = R;  % the first sources get priority
summed_expected = ones(size(summed));
while any(any(summed > summed_expected))
    mask_r = masks(:,:,r);
    for i=1:numel(summed)
        if summed(i) > 1
           mask_r(i) = 0;
        end
    end
    masks(:,:,r) = mask_r;
    summed = sum(masks, 3);
    r = r - 1;
end
