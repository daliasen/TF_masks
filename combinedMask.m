function combined_mask = combinedMask(desired, interferer, zeta)

% A mask described in the following paper:
%   Dalia Senvaityte, Johan Pauwels, and Mark Sandler. 2019. Guitar
%   String Separation Using Non-Negative Matrix Factorization and Factor
%   Deconvolution. In Audio Mostly (AM’19), September 18–20, 2019,
%   Nottingham, United Kingdom. ACM, New York, NY, USA, 5 pages.
%   https://doi.org/10.1145/3356590.3356628
%
% Note that this implementation is only suitable for mixtures of two
%   sources.
%
% Inputs:
%   1) desired - a magnitude spectrogram of the desired signal
%   2) interferer - a magnitude spectrogram of the interfering signal
%   3) zeta - balancing between a ratio mask and a binary mask, 
%       zeta = 1 corresponds to a binary mask (except for the bins where
%       desired/interferer = 1)
%
% Outputs:
%   1) combined_mask - a combination of a ratio and a binary masks

% prevent division by zero
interferer(interferer==0) = eps;

% find indices where the ratio is <= zeta && >= 1/zeta
desired_indRatio_1 = 1/zeta <= desired ./ (interferer);
desired_indRatio_2 = desired ./ (interferer) <= zeta;
desired_indRatio = desired_indRatio_1 .* desired_indRatio_2;

% ratio masks
ratio_mask = desired ./ (desired + interferer + eps);

% find indices of binary
desired_keepBinary = desired_indRatio == 0;

% binary mask i.e. > zeta
binary_mask = desired > interferer;

% populate combined mask
combined_mask = ...
    desired_keepBinary .* binary_mask + desired_indRatio .* ratio_mask;