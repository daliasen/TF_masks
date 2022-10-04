function tests = binaryMasksMaxTest
    tests = functiontests(localfunctions);
end

function sumToMixtureTest(testCase)
% Test if masked add up to the mixture with 3 sources (3 cases per source)
    source_1 = [10 10 10  0  9;  % S1 < S2 + S3, S1 = S2 + S3, S1 > S2 + S3
                 5  5  5  0  1;  % S2 < S1 + S3, S2 = S1 + S3, S2 > S1 + S3
                 5  5  5  0  1;  % S3 < S1 + S2, S3 = S1 + S2, S3 > S1 + S2
                 0  0  0  0  0];
    source_2 = [ 5  5  5  0  2;
                10 10 10  0  1;
                 6  5  4  0  1;
                 0  0  0  0  0];
    source_3 = [ 6  5  4  0  1;
                 6  5  4  0  1;
                10 10 10  0  1;
                 0  0  0  0  0];
    % M = 4 (number of frequency bins)
    % N = 5 (mixture length)
    % R = 3 (number of sources)
    
    all_sources = cat(3, source_1, source_2, source_3); % MxNxR
    
    mixture = source_1 + source_2 + source_3;
    
    masks = binaryMasksMax(all_sources);
    
    M = 4;
    N = 5;
    R = 3;
    [M_mask, N_mask, R_mask] = size(masks);
    assert(M_mask == M)
    assert(N_mask == N)
    assert(R_mask == R)
    
    masked_1 = mixture .* masks(:,:,1);
    masked_2 = mixture .* masks(:,:,2);
    masked_3 = mixture .* masks(:,:,3);
    
    masked_summed = masked_1 + masked_2 + masked_3;
    tolerance = 0.1e-14;
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end

function sumToMixtureMaskValuesTest(testCase)
% Test if masked add up to the mixture with 3 sources and check mask
%   values.
    source_1 = [8 4 1;
                1 1 1;
                1 1 2];
    source_2 = [1 1 2;
                8 4 1;
                1 1 1];
    source_3 = [1 1 1;
                1 1 2;
                8 4 1];
    % M = 3 (number of frequency bins)
    % N = 3 (mixture length)
    % R = 3 (number of sources)
    
    expected_mask_1 = [1 1 0;
                       0 0 0;
                       0 0 1];
    expected_mask_2 = [0 0 1;
                       1 1 0;
                       0 0 0];
    expected_mask_3 = [0 0 0;
                       0 0 1;
                       1 1 0];
    
    all_sources = cat(3, source_1, source_2, source_3); % MxNxR
    
    mixture = source_1 + source_2 + source_3;
    
    masks = binaryMasksMax(all_sources);

    tolerance = 0.1e-14;
    assert(isAlmostEqual(masks(:,:,1), expected_mask_1, tolerance))
    assert(isAlmostEqual(masks(:,:,2), expected_mask_2, tolerance))
    assert(isAlmostEqual(masks(:,:,3), expected_mask_3, tolerance))
    
    masked_1 = mixture .* masks(:,:,1);
    masked_2 = mixture .* masks(:,:,2);
    masked_3 = mixture .* masks(:,:,3);

    masked_summed = masked_1 + masked_2 + masked_3;

    assert(isAlmostEqual(masked_summed, mixture, tolerance))
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
    
    masks = binaryMasksMax(all_sources);

    masked_1 = mixture .* masks(:,:,1);
    masked_2 = mixture .* masks(:,:,2);
    masked_3 = mixture .* masks(:,:,3);
    masked_4 = mixture .* masks(:,:,4);
    masked_5 = mixture .* masks(:,:,5);
    masked_6 = mixture .* masks(:,:,6);

    masked_summed = masked_1 + ...
                    masked_2 + ...
                    masked_3 + ...
                    masked_4 + ...
                    masked_5 + ...
                    masked_6;

    tolerance = 0.1e-14;
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end