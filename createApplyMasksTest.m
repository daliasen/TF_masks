function tests = createApplyMasksTest
    tests = functiontests(localfunctions);
end

function sumToMixture6sourcesTest(testCase)
% Test if masked add up to the mixture with 6 sources, division by zero,
%   and several sources having equal coefficients.
    source_1 = [10 10 10  0  9;
                 5  5  5  0  1;
                 5  5  5  0  1;
                 0  0  0  0  0];
    source_2 = [ 5  5  5  0  2;
                10 10 10  0  1;
                 6  5  4  0  1;
                 0  0  0  0  0];
    source_3 = [ 6  5  4  0  1;
                 6  5  4  0  1;
                10 10 10  0  1;
                 0  0  0  0  0];
    source_4 = [ 0  5  4 10  1;
                 6  0  4  0  1;
                10 10  0  0  1;
                 0  0  0  0  0];
    source_5 = [ 6  5  4  0  1;
                 6  5  4  0  1;
                10 10 10  0  1;
                 0  0  0  0  0];
    source_6 = [ 0  5  4 10  1;
                 6  0  4  0  1;
                10 10  0  0  1;
                 0  0 20  0  0];
    % M = 4 (number of frequency bins)
    % N = 5 (mixture length)
    % R = 6 (number of sources)
    
    all_sources = cat(3, ...
                      source_1, ...
                      source_2, ...
                      source_3, ...
                      source_4, ...
                      source_5, ...
                      source_6); % MxNxR
    
    mixture = source_1 + ...
              source_2 + ...
              source_3 + ...
              source_4 + ...
              source_5 + ...
              source_6;
          
    mask_types = {struct('type', 'binary'), ...
                  struct('type', 'ratio'), ...
                  struct('type', 'sigmoid', 'p', 1), ...
                  struct('type', 'combined', 'zeta', 1)};
          
    for i=1:length(mask_types)
        maskParams = mask_types{i};
        masks = createMasks(all_sources, maskParams);

        masked = applyMasks(mixture, masks);

        masked_summed = sum(masked, 3);

        tolerance = 0.1e-14;
        error_message = ['Assertion failed, mask=' maskParams.type];
        if strcmp('sigmoid', maskParams.type)
            error_message = [error_message ', p=' num2str(maskParams.p)];
        elseif strcmp('combined', maskParams.type)            
            error_message = [error_message ', zeta=' num2str(maskParams.zeta)];
        end
        error_message = [error_message '.'];
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               error_message)
    end
end