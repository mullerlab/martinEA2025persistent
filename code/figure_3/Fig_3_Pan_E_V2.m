%% Netsim
n = 20255;
t = linspace(0,3,15000);
fid = fopen('./00000004ge.bin','rb');
ge = fread(fid, 'single');
ge = reshape(ge*10e8,50000,[]);
ge_n = ge(n,:);
fclose(fid);

fid = fopen('./00000004gn.bin','rb');
gn = fread(fid, 'single');
gn = reshape(gn*10e8,50000,[]);
gn_n = gn(n,:);
fclose(fid);

bump_ge = mean(ge_n(t>2));
base_ge = mean(ge_n(t<1));


bump_gn = mean(gn_n(t>2));
base_gn = mean(gn_n(t<1));



%% Compte
ampa = readmatrix('./ampa.txt');
nmda = readmatrix('./nmda.txt');
ampa = ampa(:,2);
nmda = nmda(:,2);
t_compte = linspace(0,3,60000);

bump_ampa = mean(ampa(t_compte>2));
base_ampa = mean(ampa(t_compte<1));

bump_nmda = mean(nmda(t_compte>2));
base_nmda = mean(nmda(t_compte<1));


%% Plotting
% Sample data (replace with your actual values)
baseline_data = [base_ampa, base_nmda, base_ge, base_gn]; % 4 data points for baseline
post_stimulus_data = [bump_ampa, bump_nmda, bump_ge, bump_gn]; % 4 paired data points for post-stimulus

% Custom colors for each point (RGB triplets, one per point)
point_colors = [
    1 0 0;    % Red
    0.5 0 1;  % Purple
    1 0 0;    % Red
    0.5 0 1;  % Purple
];

% Create the plot
figure;
hold on;

% Plot baseline points (x=1)
for i = 1:length(baseline_data)
    scatter(1, baseline_data(i), 100, point_colors(i,:), 'filled');
end

% Plot post-stimulus points (x=2)
for i = 1:length(post_stimulus_data)
    scatter(2, post_stimulus_data(i), 100, point_colors(i,:), 'filled');
end

% Connect paired points with lines
for i = 1:4
    if i <3
    plot([1 2], [baseline_data(i) post_stimulus_data(i)], ...
         'Color', point_colors(i,:), 'LineStyle', '--', 'LineWidth', 1);
    else
        plot([1 2], [baseline_data(i) post_stimulus_data(i)], ...
         'Color', point_colors(i,:), 'LineWidth', 1);
    end
end

% Customize the plot
xlim([0.5 2.5]);
xticks([1 2]);
xticklabels({'Baseline', 'Post-stimulus'});
ylabel('Conductance (ns)');
title('Conductance Measurements');


hold off;