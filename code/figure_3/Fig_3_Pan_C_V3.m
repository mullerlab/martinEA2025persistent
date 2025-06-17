%% ODR task STATISTICS
% Analysis Parameters
prefCue = 1;             % preferred (1) or nonpreferred cues (0)
binSize = 500;           % size of bins for spike counting (ms) 

% Load data
if ~exist("data","var") || ~exist("odr","var")
    load("NHPB_ODR4.mat")
    load("persistent_odr_struct.mat")
end

% Data collection
corrByTarget = cell(1, 8);
delayIdx = 2000:4000;
for ii = 1:8                                     % For each target...
idx = (odr.tuning == ii);                        % get tuned cells...
if prefCue == 1
    idxTrial = odr.targets == ii;                % in trials of that target...
else
    idxTrial = odr.targets ~= ii;                % or not of that target
end
currentRaster = data.Raster(idx, delayIdx, idxTrial);
% Spike Rates
frByTarget(ii) = {squeeze(mean(sum(currentRaster, 2) / 2))};

% CV
cvTemp = [];
for jj = 1:size(currentRaster, 3)
[a,b] = find(currentRaster(:,:,jj));
as = unique(a);
for kk = 1:length(as) 
isis =  diff(sort(b(a == as(kk))));
if length(isis) > 3
    cvTemp = [cvTemp, std(isis) / mean(isis)];
end
end
end
cvByTarget(ii) = {cvTemp};


% Correlation loop
spkCounts = movsum(currentRaster, binSize, 2);
corrByTrial = zeros(size(spkCounts,1),size(spkCounts,1),size(spkCounts,3));
for jj = 1:size(spkCounts, 3)                    % For each trial...
corrByTrial(:, :, jj) = corrcoef(spkCounts(:, :, jj)');
end
corrByTarget(ii) = {mean(corrByTrial, 3, 'omitmissing')}; 
end

all = [];
for ii = 1:8 
mask = tril(true(size(corrByTarget{ii})), -1);
temp = corrByTarget{ii}(mask);
all = [all; temp];
end
%% MODEL STATISTICS

% Import spiking data
load("sim2_spike_times_ids.mat")

% Raster firing distribution
test = ids(times > 2);
test = test(test > 20000 & test < 21000);
counting = histcounts(test, 20000:21000);
unique_rates = unique(counting);
num_appearance = histcounts(counting, [unique_rates, max(unique_rates) + 1]);

% CV
CVs = [];
for k = 20000:21000
    spike_train = times(ids == k & times > 1 & times < 2);
    if length(spike_train) > 3
        isis = diff(spike_train);
        CVs = [CVs; std(isis) / mean(isis)];
    end
end
CVs = rmmissing(CVs);

% Correlation
start = 20000;
stop = 21000;
binSize = 500; % tenths of ms
timeIdx = 2/1e-4:3/1e-4; 
raster = full(sparse(int32(ids), int32(times*10000), 1, 50000, 30000));
spkCounts = movsum(raster(20000:21000, timeIdx), binSize, 2);                
corr_ = corrcoef(spkCounts');
mask = tril(true(size(corr_)), -1);
corr = mean(corr_(mask), 'omitmissing');
corr_=corr_(mask);


%% PLOTTING

% Create a tiled layout with 1 row and 3 columns
figure('Units', 'inches', 'Position', [0, 0, 3.5, 12], 'Color', 'w');
tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');
sz=51;
% Set common properties
set(groot, 'defaultAxesFontName', 'Arial', 'defaultAxesFontSize', 16, ...
    'defaultAxesColor', 'w', 'defaultAxesXColor', 'k', 'defaultAxesYColor', 'k');

% Panel 1: Raster firing distribution
nexttile;
% model
bin_width = unique_rates(2) - unique_rates(1); % Calculate bin width
pdf_values = num_appearance / (sum(num_appearance) * bin_width); % Normalize to PDF
% Reduce number of bars by averaging every 2 bins
new_rates = mean([unique_rates(1:4:end); unique_rates(2:4:end)]); 
new_pdf = mean([pdf_values(1:4:end); pdf_values(2:4:end)]);
bar(new_rates, new_pdf, 'FaceColor', [0.8, 0.475, 0.655], 'EdgeColor', 'none', 'BarWidth', 1);
ylabel('Density');
xlabel('Firing Rate (sp/s)');
%ylabel('Count');
set(gca, 'Color', 'w', 'LineWidth', 2, 'TickDir', 'out');
box off;
hold on;
%ODR data
histogram(vertcat(frByTarget{:}), 7,'EdgeColor','none','FaceColor',[0 0.619 0.451],Normalization="pdf")
set(gca, 'Box', 'off', 'TickDir', 'out', 'FontSize', 15, 'FontWeight', 'bold');
legend("in silico","in vivo",'Position', [.7, 0.8, .05, .12],'FontSize', 10)
legend boxoff

% Panel 2: CV
nexttile;
%model
histogram(CVs, 17, 'FaceColor', [0.8, 0.475, 0.655], 'EdgeColor', 'none',Normalization="pdf");
xlabel('CV');
ylabel('Count','FontSize', 15);
set(gca, 'Color', 'w', 'LineWidth', 2, 'TickDir', 'out');
box off;
hold on;
%ODR task
histogram(horzcat(cvByTarget{:}),25,'EdgeColor','none','FaceColor',[0 0.619 0.451],Normalization="pdf")
set(gca, 'Box', 'off', 'TickDir', 'out', 'FontSize', 15, 'FontWeight', 'bold');
xlim([-0.2 2.2])

% Panel 2: Correlation
nexttile;
%model
histogram(corr_, 30,'FaceColor', [0.8, 0.475, 0.655], 'EdgeColor', 'none',Normalization="pdf");
xlabel('Correlation');
ylabel('Count','FontSize', 15);
set(gca, 'Color', 'w', 'LineWidth', 2, 'TickDir', 'out');
box off;
hold on;
%ODR task
histogram(all, 20, 'EdgeColor','none','FaceColor',[0 0.619 0.451],Normalization="pdf")
set(gca, 'Box', 'off', 'TickDir', 'out', 'FontSize', 15, 'FontWeight', 'bold');
ylabel( "Density",'FontSize', 15)
ylim([0 4])
xlim([-0.6 0.6])

