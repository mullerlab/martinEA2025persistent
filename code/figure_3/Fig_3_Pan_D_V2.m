% Import spiking data
load("n_20255.mat")
% import network clamp data
path = "./24728063.abf"
[data,si,header]=abfload(path);
num_points = header.dataPtsPerChan;
sampling_rate = header.fADCSampleInterval * 1e-6; % in microseconds
t2 = linspace(0, (num_points - 1) * sampling_rate*2, num_points);

voltage = data(:,1); % 


%find beginning of stimulation
start= t(find(stim>40,1));
voltage = voltage(t2>=start & t2< start+3);
t2 = linspace(0,3,150000);
%% plot voltage traces model neuron

for i = 1:length(timings_20255)
Vm_20255(floor(timings_20255(i)/2e-4))=50;
end

t1 = linspace(0,3,15000);

%% PLOTTING

figure('Units', 'inches', 'Position', [1, 0.8, 8, 7.4])
tiledlayout(4, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

nexttile;
plot(t1,Vm_20255,'LineWidth', 1.8,'Color',[1 0.6 0.1])
line([0 3], [-50 -50], 'LineStyle', '--', 'Color', [0.5 0.5 0.5]);
hold on 
fill([1 2 2 1], [-80 -80 50 50], [0.5 0.5 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
axis off
text(0, -55, '-50 mV ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
%scale
text(-.05, 17, '-20 mV ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
text(0.15, -5, '200 ms ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
line([-0.01, -0.01], [10, 30],'Color', 'k', 'LineWidth', 2);
line([-0.01, 0.19], [10, 10],'Color', 'k', 'LineWidth', 2);


nexttile;
plot(t2,voltage.','LineWidth', 1.8,'Color',[0 0.5 0.3])
line([0 3], [-50 -50], 'LineStyle', '--', 'Color', [0.5 0.5 0.5]);
hold on 
fill([1 2 2 1], [-80 -80 50 50], [0.5 0.5 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
axis off
text(0, -55, '-50 mV ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
%scale
text(.05, 17, '-20 mV ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
text(0.15, -5, '200 ms ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
line([-0.01, -0.01], [10, 30],'Color', 'k', 'LineWidth', 2);
line([-0.01, 0.19], [10, 10],'Color', 'k', 'LineWidth', 2);

nexttile;
plot(t1,gi_20255,'LineWidth', 1.8,'Color',[0 0 0.9])
ylim([0 300])
hold on 
axis off
%scale
text(-.05, 17, '80 nS ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
text(0.15, -5, '200 ms ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
line([-0.01, -0.01], [50, 130],'Color', 'k', 'LineWidth', 2);
line([-0.01, 0.19], [50, 50],'Color', 'k', 'LineWidth', 2);

nexttile;

plot(t1,ge_20255,'LineWidth', 1.8,'Color',[1 0 0])
hold on ; plot(t1,gn_20255,'LineWidth', 1.8,'Color',[0.7 0.1 0.4])

axis off
%scale
text(-.05, 10, '2 nS ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
text(0.15, 8, '200 ms ', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 15, 'FontWeight', 'bold');
line([-0.01, -0.01], [10, 13],'Color', 'k', 'LineWidth', 2);
line([-0.01, 0.19], [10, 10],'Color', 'k', 'LineWidth', 2);