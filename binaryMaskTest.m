function tests = binaryMaskTest
    tests = functiontests(localfunctions);
end

function sumToMixtureZeroTest(testCase)
% Test if masked add up to the mixture with division by zero.
    source_1 = [10 10 10  0  2;
                 5  5  5  0  1;
                 5  5  5  0  1;
                 0  0  0  0  0];
    source_2 = [ 5  5  5  0  9;
                10 10 10  0  1;
                 6  5  4  0  1;
                 0  0  0  0  0];
    % M = 4 (number of frequency bins)
    % N = 5 (mixture length)
    % R = 2 (number of sources)
    
    mixture = source_1 + source_2;
    
    [mask_1, mask_2] = binaryMask(source_1, source_2);

    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;

    masked_summed = masked_1 + masked_2;

    tolerance = 0.1e-14;
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end

function sumToMixtureMaskTest(testCase)
% Test if masked add up to the mixture and check mask values.
    
    source_1 = [8 4 1;
                1 1 1;
                1 1 2];
    source_2 = [1 1 2;
                8 4 1;
                1 1 1];
    % M = 3 (number of frequency bins)
    % N = 3 (mixture length)
    % R = 2 (number of sources)
    
    expected_mask_1 = [1 1 0;  % desired/interferer =8/1, =4/1, =1/2
                       0 0 0;  % desired/interferer =1/8, =1/4, =1/1
                       0 0 1];  % desired/interferer =1/1, =1/1, =2/1
                   
    expected_mask_2 = [0 0 1;  % desired/interferer =1/8, =1/4, =2/1
                       1 1 1;  % desired/interferer =8/1, =4/1, =1/1
                       1 1 0];  % desired/interferer =1/1, =1/1, =1/2
    
    mixture = source_1 + source_2;
    
    [mask_1, mask_2] = binaryMask(source_1, source_2);
    
    tolerance = 0.1e-14;
    assert(isAlmostEqual(mask_1, expected_mask_1, tolerance))
    assert(isAlmostEqual(mask_2, expected_mask_2, tolerance))
    
    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    
    masked_summed = masked_1 + masked_2;
    
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end