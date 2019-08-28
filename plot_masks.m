% Plot mask coefficient mapping with respect to a ratio mask

folder = 'results\';
ExportFigs = [1 0 0];

len = 1024;
desired = ones(1,len)/2;
ratio_mask_ratios = linspace(0,len,len)/len; %[0;1]
interferer = 0.5./(ratio_mask_ratios + eps) - 0.5; % [1;0]

zeta1 = 1.5;
combined_mask_1 = combinedMask(desired,interferer,zeta1);
zeta2 = 3;
combined_mask_2 = combinedMask(desired,interferer,zeta2);

ratio_mask = ratioMask(desired,interferer);

binary_mask = binaryMask(desired,interferer);

all_sources(1,:,:) = desired;
all_sources(2,:,:) = interferer;
p1 = 2;
sigmoid_mask_1 = sigmoidMask(desired,all_sources,p1);
p2 = 10;
sigmoid_mask_2 = sigmoidMask(desired,all_sources,p2);

newFig(1);

lineWidth = 2;

plot(ratio_mask_ratios,binary_mask,':','LineWidth',lineWidth,'Color',[0.4940    0.1840    0.5560])
% gtext('Binary');

% get(gca,'colororder')
hold on

plot(ratio_mask_ratios,ratio_mask,'--','LineWidth',lineWidth,'Color',[0    0.4470    0.7410])
% gtext('Ratio');

plot(ratio_mask_ratios,sigmoid_mask_1,'-','LineWidth',lineWidth,'Color',[0.8500    0.3250    0.0980])
% gtext(['Sigmoid, p=' num2str(p1)]);
plot(ratio_mask_ratios,sigmoid_mask_2,'-','LineWidth',lineWidth,'Color',[0.8510    0.5647    0.4431])
% gtext(['Sigmoid, p=' num2str(p2)]);

plot(ratio_mask_ratios,combined_mask_1,'-.','LineWidth',lineWidth,'Color',[0.9290    0.6940    0.1250])
% gtext(['Combined, \zeta=' num2str(zeta1)]);
plot(ratio_mask_ratios,combined_mask_2,'-.','LineWidth',lineWidth,'Color',[0.9294    0.8039    0.5020])
% gtext(['Combined, \zeta=' num2str(zeta2)]);

hold off

ylabel('Mask coefficients')
xlabel('Ratio mask coefficients')

legend({'Binary', ...
        'Ratio', ...
        ['Sigmoid, p=' num2str(p1)], ...
        ['Sigmoid, p=' num2str(p2)], ...
        ['Combined, \zeta=' num2str(zeta1)], ...
        ['Combined, \zeta=' num2str(zeta2)]}, ...
       'Location','southeast')

pbaspect([1 1 1])
h = gcf;
exportFig(h, [folder 'masks'], ExportFigs)


