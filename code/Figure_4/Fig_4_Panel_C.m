
% import data files
squarepulse_naive = "./24_8_23/24823033.abf";
squarepulse_dopamine = "./24_8_23/24823035.abf";
naive_file = "./24_8_29/24829034.abf";
dopamine_file = "./24_8_29/24829045.abf";

%import naive squarepulse data
[naive_data,si,header]=abfload(squarepulse_naive);
num_points = header.sweepLengthInPts;
sampling_rate = header.fADCSampleInterval * 1e-6; % in microseconds
t = linspace(0, (num_points - 1) * sampling_rate, num_points);

initial_stim = header.DACEpoch.fEpochInitLevel(4);
step = header.DACEpoch.fEpochLevelInc(4);

%import dopamine
[dopamine_data,si,header]=abfload(squarepulse_dopamine);

%% Plotting
figure('Units', 'inches', 'Position', [0, 0.4, 7.8, 7.8], 'Color', 'w');
tiledlayout(3, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');
% Set common properties
set(groot, 'defaultAxesFontName', 'Arial', 'defaultAxesFontSize', 16, ...
    'defaultAxesColor', 'w', 'defaultAxesXColor', 'k', 'defaultAxesYColor', 'k');

% Panel 1: 
nexttile;
create_panel(naive_data,t,10,[0 0 0.6]);
nexttile;
create_panel(dopamine_data,t,10,[0.6 0 0]);
nexttile;
create_panel(naive_data,t,9,[0 0 0.6]);
nexttile;
create_panel(dopamine_data,t,9,[0.6 0 0]);
nexttile;
create_panel(naive_data,t,1:1:8,[0 0 0.6]);
xlabel('Time (ms)', 'Fontsize', 21);
nexttile;
create_panel(dopamine_data,t,1:1:8,[0.6 0 0]);
xlabel('Time (ms)', 'Fontsize', 21);
%%
function create_panel(data,t, sweeps,color)

    warning('off', 'signal:findpeaks:largeMinPeakHeight');

    % Convert single sweep number to array for uniform handling
    if isscalar(sweeps)
        sweeps = [sweeps];
    end

    for i = 1:length(sweeps)
        sweep = sweeps(i);
        if sweep <= size(data, 3)  % Check if sweep exists
            trace = lowpass(data(:, 1, sweep), 0.09);
            plot(t.', trace, 'LineWidth', 2, 'Color', color);
            hold on;
        end
    end
    
    box off;
    set(gca, 'Fontsize', 21, 'TickDir', 'out');
    ylim([-120 60]);
    xlim([0.35 2]);
    ylabel('Voltage (mV)', 'Fontsize', 21);
end