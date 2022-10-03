function tests = sigmoidMaskTest
    tests = functiontests(localfunctions);
end

function sumToMixture3sourcesTest(testCase)
% Test if masked add up to the mixture with 3 sources (3 cases per source)
%   and multiple powers.
    powers = [1 1.25 1.5 2.75 3 4 10 20];
    source_1 = [10 10 10;   % S1 < S2 + S3, S1 = S2 + S3, S1 > S2 + S3
                 5  5  5;   % S2 < S1 + S3, S2 = S1 + S3, S2 > S1 + S3
                 5  5  5];  % S3 < S1 + S2, S3 = S1 + S2, S3 > S1 + S2                 
    source_2 = [ 5  5  5;
                10 10 10;
                 6  5  4];
    source_3 = [ 6  5  4;
                 6  5  4;
                10 10 10];
    % M = 3 (number of frequency bins)
    % N = 3 (mixture length)
    % R = 3 (number of sources)
    
    all_sources = cat(3, source_1, source_2, source_3); % MxNxR
    all_sources = permute(all_sources, [3 1 2]); % RxMxN
    
    mixture = source_1 + source_2 + source_3;
    
    for i=1:length(powers)
        p = powers(i);
        mask_1 = sigmoidMask(source_1, all_sources, p);
        mask_2 = sigmoidMask(source_2, all_sources, p);
        mask_3 = sigmoidMask(source_3, all_sources, p);

        masked_1 = mixture .* mask_1;
        masked_2 = mixture .* mask_2;
        masked_3 = mixture .* mask_3;

        masked_summed = masked_1 + masked_2 + masked_3;

        tolerance = 0.1e-12;
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (p=' num2str(p) ').'])
    end
end

function sumToMixture6sourcesTest(testCase)
% Test if masked add up to the mixture with 6 sources and division by zero
%   with multiple powers, check mask dimensions.
    powers = [1 1.25 1.5 2.75 3 4 10 20];
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
    M = 4; % number of frequency bins
    N = 5; % mixture length
    % R = 6 (number of sources)
    
    all_sources = cat(3, ...
                      source_1, ...
                      source_2, ...
                      source_3, ...
                      source_4, ...
                      source_5, ...
                      source_6); % MxNxR
    all_sources = permute(all_sources, [3 1 2]); % RxMxN
    
    mixture = source_1 + ...
              source_2 + ...
              source_3 + ...
              source_4 + ...
              source_5 + ...
              source_6;
          
    for i=1:length(powers)
        p = powers(i);
        mask_1 = sigmoidMask(source_1, all_sources, p);
        mask_2 = sigmoidMask(source_2, all_sources, p);
        mask_3 = sigmoidMask(source_3, all_sources, p);
        mask_4 = sigmoidMask(source_4, all_sources, p);
        mask_5 = sigmoidMask(source_5, all_sources, p);
        mask_6 = sigmoidMask(source_6, all_sources, p);
        
        [M_mask, N_mask] = size(mask_1);
        assert(M_mask == M, ['Assertion failed (p=' num2str(p) ').'])
        assert(N_mask == N, ['Assertion failed (p=' num2str(p) ').'])

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

        tolerance = 0.1e-12;
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (p=' num2str(p) ').'])
    end
end

function sumToMixture3sourcesPowerOneTest(testCase)
% Test if masked add up to the mixture with 3 sources and check mask values
%   when power = 1.
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
    
    % power = 1 should corresponds to a ratio mask
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
    all_sources = permute(all_sources, [3 1 2]); % RxMxN
    
    mixture = source_1 + source_2 + source_3;
    
    p = 1;
    
    mask_1 = sigmoidMask(source_1, all_sources, p);
    mask_2 = sigmoidMask(source_2, all_sources, p);
    mask_3 = sigmoidMask(source_3, all_sources, p);

    tolerance = 0.1e-12;
    assert(isAlmostEqual(mask_1, expected_mask_1, tolerance))
    assert(isAlmostEqual(mask_2, expected_mask_2, tolerance))
    assert(isAlmostEqual(mask_3, expected_mask_3, tolerance))

    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    masked_3 = mixture .* mask_3;

    masked_summed = masked_1 + masked_2 + masked_3;

    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end

function sumToMixture2sourcesTest(testCase)
% Test if masked add up to the mixture with 2 sources and multiple powers.
    powers = [1 1.25 1.5 2.75 3 4 10 20];
    
    source_1 = [ 1  2  3  4; 5  6  7  8; 90 100 110 120];
    source_2 = [10 20 30 40; 5  6  7  8;  9  10  11  12];
    % M = 3 (number of frequency bins)
    % N = 4 (mixture length)
    % R = 2 (number of sources)
    
    all_sources = cat(3, source_1, source_2); % MxNxR
    all_sources = permute(all_sources, [3 1 2]); % RxMxN
    
    mixture = source_1 + source_2;
    
    for i=1:length(powers)        
        p = powers(i);
        mask_1 = sigmoidMask(source_1, all_sources, p);
        mask_2 = sigmoidMask(source_2, all_sources, p);

        masked_1 = mixture .* mask_1;
        masked_2 = mixture .* mask_2;

        masked_summed = masked_1 + masked_2;

        tolerance = 0.1e-12;
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (p=' num2str(p) ').'])
    end
end

function mask2sourcesPowerOneTest(testCase)
% Test if masked add up to the mixture with 2 sources and check mask values
%   when power = 1.
    p = 1;
    
    source_1 = [8 4 1;
                1 1 1;
                1 1 2];
    source_2 = [1 1 2;
                8 4 1;
                1 1 1];
    % M = 3 (number of frequency bins)
    % N = 3 (mixture length)
    % R = 2 (number of sources)
        
    % power = 1 should corresponds to a ratio mask
    expected_mask_1 = [8/9 4/5 1/3;   % desired/interferer =8/1, =4/1, =1/2
                       1/9 1/5 0.5; % desired/interferer =1/8, =1/4, =1/1
                       0.5 0.5 2/3];  % desired/interferer =1/1, =1/1, =2/1
    expected_mask_2 = [1/9 1/5 2/3;   % desired/interferer =1/8, =1/4, =2/1
                       8/9 4/5 0.5; % desired/interferer =8/1, =4/1, =1/1
                       0.5 0.5 1/3];  % desired/interferer =1/1, =1/1, =1/2
    
    mixture = source_1 + source_2;
    
    all_sources = cat(3, source_1, source_2); % MxNxR    
    all_sources = permute(all_sources, [3 1 2]); % RxMxN
    
    mask_1 = sigmoidMask(source_1, all_sources, p);
    mask_2 = sigmoidMask(source_2, all_sources, p);
    
    tolerance = 0.1e-12;
    assert(isAlmostEqual(mask_1, expected_mask_1, tolerance))
    assert(isAlmostEqual(mask_2, expected_mask_2, tolerance))
    
    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    
    masked_summed = masked_1 + masked_2;
    
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end