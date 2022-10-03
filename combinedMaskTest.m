function tests = combinedMaskTest
    tests = functiontests(localfunctions);
end

function sumToMixtureTest(testCase)
% Test if masked add up to the mixture with division by zero and multiple
%   zeta values.
    zetas = [1 1.25 1.5 2.75 3 4 10 100 1000];
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
    
    for z=1:length(zetas)
        zeta = zetas(z);
    
        mask_1 = combinedMask(source_1, source_2, zeta);
        mask_2 = combinedMask(source_2, source_1, zeta);

        masked_1 = mixture .* mask_1;
        masked_2 = mixture .* mask_2;

        masked_summed = masked_1 + masked_2;

        tolerance = 0.1e-14;
        assert(isAlmostEqual(masked_summed, mixture, tolerance), ...
               ['Assertion failed (zeta=' num2str(zeta) ').'])
    end
end

function sumToMixtureRatiosTest(testCase)
% Test if masked add up to the mixture with 3 cases of desired and
%    interfering ratio compared to multiple zeta = 2:
%       desired / interfering > zeta
%       1 / zeta <= desired / interfering <= zeta
%       desired / interfering < 1/zeta
    source_1 = [8 4 1;
                1 1 1;
                1 1 2];
    source_2 = [1 1 2;
                8 4 1;
                1 1 1];
    % R = 2 (number of sources)
    % M = 3 (number of frequency bins)
    % N = 3 (mixture length)
    
    mixture = source_1 + source_2;
    
    zeta = 2;
    
    mask_1 = combinedMask(source_1, source_2, zeta);
    mask_2 = combinedMask(source_2, source_1, zeta);
    
    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    
    masked_summed = masked_1 + masked_2;
    
    tolerance = 0.1e-14;
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end

function zetaOneTest(testCase)
% Test if masked add up to the mixture and check mask values when
%   zeta = 1.
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
    
    mask_1 = combinedMask(source_1, source_2, zeta);
    mask_2 = combinedMask(source_2, source_1, zeta);
    
    tolerance = 0.1e-14;
    assert(isAlmostEqual(mask_1, expected_mask_1, tolerance))
    assert(isAlmostEqual(mask_2, expected_mask_2, tolerance))
    
    masked_1 = mixture .* mask_1;
    masked_2 = mixture .* mask_2;
    
    masked_summed = masked_1 + masked_2;
    
    assert(isAlmostEqual(masked_summed, mixture, tolerance))
end