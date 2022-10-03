function tests = ratioMaskTest
    tests = functiontests(localfunctions);
end

function sumToMixture2Test(testCase)
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
    % R = 3 (number of sources)
    % M = 4 (number of frequency bins)
    % N = 5 (mixture length)
    
    mixture = source_1 + source_2 + source_3;
    
    mask_1 = ratioMask(source_1, source_2 + source_3);
    mask_2 = ratioMask(source_2, source_1 + source_3);
    mask_3 = ratioMask(source_3, source_2 + source_1);
    
    M = 4;
    N = 5;
    [M_mask, N_mask] = size(mask_1);
    assert(M_mask == M)
    assert(N_mask == N)
    
    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    masked_3 = mixture .* mask_3;
    
    masked_summed = masked_1 + masked_2 + masked_3;
    tolerance = 0.1e-14;
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end

function sumToMixture3sourcesZetaOneTest(testCase)
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
    
    expected_mask_1 = [0.8 4/6 0.25;
                       0.1 1/6 0.25;
                       0.1 1/6 0.5];
    expected_mask_2 = [0.1 1/6 0.5;
                       0.8 4/6 0.25;
                       0.1 1/6 0.25];
    expected_mask_3 = [0.1 1/6 0.25;
                       0.1 1/6 0.5;
                       0.8 4/6 0.25];
    
    all_sources = cat(3, source_1, source_2, source_3); % MxNxR
    
    mixture = source_1 + source_2 + source_3;
    
    mask_1 = ratioMask(source_1, source_2 + source_3);
    mask_2 = ratioMask(source_2, source_1 + source_3);
    mask_3 = ratioMask(source_3, source_2 + source_1);

    tolerance = 0.1e-14;
    assert(isAlmostEqual(mask_1, expected_mask_1, tolerance))
    assert(isAlmostEqual(mask_2, expected_mask_2, tolerance))
    assert(isAlmostEqual(mask_3, expected_mask_3, tolerance))
    
    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    masked_3 = mixture .* mask_3;

    masked_summed = masked_1 + masked_2 + masked_3;

    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end

function sumToMixture4sourcesTest(testCase)
% Test if masked add up to the mixture with 6 sources and division by zero.
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
    
    mixture = source_1 + ...
              source_2 + ...
              source_3 + ...
              source_4 + ...
              source_5 + ...
              source_6;
    
    mask_1 = ratioMask(source_1, source_2 + source_3 + source_4 + source_5 + source_6);
    mask_2 = ratioMask(source_2, source_1 + source_3 + source_4 + source_5 + source_6);
    mask_3 = ratioMask(source_3, source_1 + source_2 + source_4 + source_5 + source_6);
    mask_4 = ratioMask(source_4, source_1 + source_2 + source_3 + source_5 + source_6);
    mask_5 = ratioMask(source_5, source_1 + source_2 + source_3 + source_4 + source_6);
    mask_6 = ratioMask(source_6, source_1 + source_2 + source_3 + source_4 + source_5);

    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    masked_3 = mixture .* mask_3;
    masked_4 = mixture .* mask_4;
    masked_5 = mixture .* mask_5;
    masked_6 = mixture .* mask_6;

    masked_summed = masked_1 + ...
                    masked_2 + ...
                    masked_3 + ...
                    masked_4 + ...
                    masked_5 + ...
                    masked_6;

    tolerance = 0.1e-14;
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end