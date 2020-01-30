function masked_TF_array = maskAllMasks(est_sources, mixture_TF, maskParamsArray)

% Inputs:
%   1) est_sources - magnitude spectrograms of the estimated sources, with 
%       dimensions RxMxN:
%           M - frequency bins
%           R - sources i.e. bases
%           N - mixture length
%   2) mixture_TF - a time-frequency representation of the mixture
%   3) maskParamsArray - a cell array of maskParams containing 
%       time-frequency mask parameters:
%           maskParams.type - mask name (binary-max, binary-sum, ratio, 
%               combined or sigmoid)
%           maskParams.p - power for the sigmoid mask
%           maskParams.zeta - balance between the ratio and the binary 
%               masks for the combined mask
%
% Outputs:
%   1) masked_TF_array - an array of structures containing the following 
%       fields:
%           value - all sources extracted from the mixture using the
%               corresponding masks
%           name - the corresponding mask type (and the parameter for
%               sigmoid and combined masks)

for i=1:length(maskParamsArray)
    masked_TF_array(i).value = mask(est_sources, mixture_TF, maskParamsArray{i});
    name = maskParamsArray{i}.type;
    if isfield(maskParamsArray{i}, 'p')
        name = [name '-' int2str(maskParamsArray{i}.p)];
    elseif isfield(maskParamsArray{i}, 'zeta')
        name = [name '-' int2str(maskParamsArray{i}.zeta)];
    end
    masked_TF_array(i).name = name;
end