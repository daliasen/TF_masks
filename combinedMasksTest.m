function tests = combinedMasksTest    
    tests = functiontests(localfunctions);
end

function sumToMixture3sourcesTest(testCase)
% Test if masked add up to the mixture with 3 sources (3 cases per source)
%   and multiple zeta values.
    zetas = [1 1.25 1.5 2.75 3 4 10 100 1000];
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
    
    mixture = source_1 + source_2 + source_3;
    
    for z=1:length(zetas)
        zeta = zetas(z);
        masks = combinedMasks(all_sources, zeta);

        masked_1 = mixture .* masks(:,:,1);
        masked_2 = mixture .* masks(:,:,2);
        masked_3 = mixture .* masks(:,:,3);

        masked_summed = masked_1 + masked_2 + masked_3;

        tolerance = 0.1e-14;
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (zeta=' num2str(zeta) ').'])
    end
end

function sumToMixture4sourcesTest(testCase)
% Test if masked add up to the mixture with 6 sources and division by zero
%   with multiple zeta values.
    zetas = [1 1.25 1.5 2.75 3 4 10 100 1000];
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
    R = 6; % number of sources
    
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
    
    for z=1:length(zetas)
        zeta = zetas(z);

        masks = combinedMasks(all_sources, zeta);
        
        [M_mask, N_mask, R_mask] = size(masks);
        assert(M_mask == M, ['Assertion failed (zeta=' num2str(zeta) ').'])
        assert(N_mask == N, ['Assertion failed (zeta=' num2str(zeta) ').'])
        assert(R_mask == R, ['Assertion failed (zeta=' num2str(zeta) ').'])

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
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (zeta=' num2str(zeta) ').'])
    end
end

function sumToMixture3sourcesRatiosTest(testCase)
% Test if masked add up to the mixture with 3 sources and
%   3 cases of desired and interfering ratio compared to multiple zetas:
%       desired / interfering > zeta
%       1 / zeta <= desired / interfering <= zeta
%       desired / interfering < 1/zeta
    zetas = [1 1.25 1.5 2.75 3 4 10 100 1000];
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
    
    all_sources = cat(3, source_1, source_2, source_3); % MxNxR
    
    mixture = source_1 + source_2 + source_3;
    
    for z=1:length(zetas)
        zeta = zetas(z);
    
        masks = combinedMasks(all_sources, zeta);

        tolerance = 0.1e-14;

        masked_1 = mixture .* masks(:,:,1);
        masked_2 = mixture .* masks(:,:,2);
        masked_3 = mixture .* masks(:,:,3);

        masked_summed = masked_1 + masked_2 + masked_3;

        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (zeta=' num2str(zeta) ').'])
    end
end

function sumToMixture3sourcesZetaOneTest(testCase)
% Test if masked add up to the mixture with 3 sources and check mask values
%   when zeta = 1.
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
    
    % zeta = 1 should corresponds to a binary mask
    % (except for the bins where desired/interferer = 1).
    expected_mask_1 = [1 1 0.25;
                       0 0 0.25;
                       0 0 0.5];
    expected_mask_2 = [0 0 0.5;
                       1 1 0.25;
                       0 0 0.25];
    expected_mask_3 = [0 0 0.25;
                       0 0 0.5;
                       1 1 0.25];
    
    all_sources = cat(3, source_1, source_2, source_3); % MxNxR
    
    mixture = source_1 + source_2 + source_3;
    
    zeta = 1;

    masks = combinedMasks(all_sources, zeta);

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

function sumToMixture2sourcesTest(testCase)
% Test if masked add up to the mixture with 2 sources and multiple zeta
%   values.
    zetas = [1 1.25 1.5 2.75 3 4 10 100 1000];
    
    source_1 = [ 1  2  3  4; 5  6  7  8; 90 100 110 120];
    source_2 = [10 20 30 40; 5  6  7  8;  9  10  11  12];
    % M = 3 (number of frequency bins)
    % N = 4 (mixture length)
    % R = 2 (number of sources)
    
    all_sources = cat(3, source_1, source_2); % MxNxR
    
    mixture = source_1 + source_2;
    
    for z=1:length(zetas)
        zeta = zetas(z);
    
        masks = combinedMasks(all_sources, zeta);

        masked_1 = mixture .* masks(:,:,1);
        masked_2 = mixture .* masks(:,:,2);

        masked_summed = masked_1 + masked_2;

        tolerance = 0.1e-14;
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (zeta=' num2str(zeta) ').'])
    end
end

function mask2sourcesZetaOneTest(testCase)
% Test if masked add up to the mixture with 2 sources and check mask values
%   when zeta = 1.
    zeta = 1;
    
    source_1 = [8 4 1;
                1 1 1;
                1 1 2];
    source_2 = [1 1 2;
                8 4 1;
                1 1 1];
    % M = 3 (number of frequency bins)
    % N = 3 (mixture length)
    % R = 2 (number of sources)
    
    % zeta = 1 should corresponds to a binary mask
    %   (except for the bins where desired/interferer = 1)
    expected_mask_1 = [1   1   0;   % desired/interferer =8/1, =4/1, =1/2
                       0   0   0.5; % desired/interferer =1/8, =1/4, =1/1
                       0.5 0.5 1];  % desired/interferer =1/1, =1/1, =2/1
    expected_mask_2 = [0   0   1;   % desired/interferer =1/8, =1/4, =2/1
                       1   1   0.5; % desired/interferer =8/1, =4/1, =1/1
                       0.5 0.5 0];  % desired/interferer =1/1, =1/1, =1/2
    
    mixture = source_1 + source_2;
    
    all_sources = cat(3, source_1, source_2); % MxNxR
    masks = combinedMasks(all_sources, zeta);
    
    tolerance = 0.1e-14;
    assert(isAlmostEqual(masks(:,:,1), expected_mask_1, tolerance))
    assert(isAlmostEqual(masks(:,:,2), expected_mask_2, tolerance))
    
    masked_1 = mixture .* masks(:,:,1);
    masked_2 = mixture .* masks(:,:,2);
    
    masked_summed = masked_1 + masked_2;
    
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end