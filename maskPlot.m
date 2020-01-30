function [ax, h] = maskPlot(mask,w,overlap,fs,plot_title)

% Input:
%   1) mask - a matrix produced with the ratioMask function
%   2) w - the window size that was used in the stft function (for the time
%       axis)
%   3) overlap - percentage of overlap that was used in stft function (for 
%       one of the axis)
%   4) fs - sampling frequency
%   5) plot_title - plot title 
%
% Output: 
%   A figure displaying mask coefficients in grey scale
%   1) ax - axis handle
%   2) h - colorbar

hop = hopSize(w,overlap);
[rows,columns] = size(mask);
X = (((1:columns)-1)*hop+w/2)/fs; % time, segment index to seconds (columns)
Y = fs*(0:rows-1)/((rows-1)*2); % frequency, index to Hz) (rows)

pcolor(X,Y,mask)
shading flat
colormap(gray)
h = colorbar;
caxis([0 1])
ylabel(h, 'Mask Coefficients', 'FontSize', 9)
title(plot_title, 'FontSize', 9)
xlabel('Time, s', 'FontSize', 9)
ylabel('Frequency, Hz', 'FontSize', 9)
set(gca,'fontsize',9)

ax = gca;