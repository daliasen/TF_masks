function combined_masks = combinedMasks(all_sources, zeta)
% Time-frequency masks based on the mask described in the following paper:
%   Dalia Senvaityte, Johan Pauwels, and Mark Sandler. 2019. Guitar
%   String Separation Using Non-Negative Matrix Factorization and Factor
%   Deconvolution. In Audio Mostly (AM’19), September 18–20, 2019,
%   Nottingham, United Kingdom. ACM, New York, NY, USA, 5 pages.
%   https://doi.org/10.1145/3356590.3356628
%
% Inputs:
%   1) all_sources - magnitude spectrograms of all sources (can be more
%       than two), with dimentions
%       MxNxR:
%           M - frequency bins
%           N - mixture length
%           R - sources
%   3) zeta - balancing between a ratio mask and a binary mask, 
%       zeta = 1 corresponds to a binary mask (except for the bins where
%       desired/interferer = 1)
%
% Outputs:
%   1) combined_masks - a combination of a ratio and a binary masks for
%       each source, with dimentions MxNxR:
%           M - frequency bins
%           N - mixture length
%           R - sources

[M, N, R] = size(all_sources);
ratio_masks = zeros(M, N, R);
all_source_indeces = linspace(1, R, R);
ratio_more_than_zeta_masks = zeros(M, N, R);
for r=1:R
    interferer_indeces = all_source_indeces(1:end ~= r);
    
    desired = all_sources(:,:,r);
    interferers = all_sources(:,:,interferer_indeces);
    
    ratio_masks(:,:,r) = ratioMask(desired, sum(interferers, 3));
    
    ratio_more_than_zeta_masks(:,:,r) = ...
        desired ./ (sum(interferers, 3) + eps) > zeta;
end

binary_masks = binaryMasksMax(all_sources);

keep_binary = sum(ratio_more_than_zeta_masks, 3);
keep_ratio = ~keep_binary;

combined_masks = zeros(M, N, R);
for r=1:R
    binary_mask = binary_masks(:,:,r);
    ratio_mask = ratio_masks(:,:,r);
    combined_masks(:,:,r) = ...
        keep_binary .* binary_mask + ...
        keep_ratio .* ratio_mask;
end