% Import spiking data
fid = fopen('../data/Clustered Netsim model/00000004spk_times.bin','rb');
times = fread(fid, 'double') ;
fclose(fid);
fid = fopen('../data/Clustered Netsim model/00000004spk_ids.bin','rb');
ids = fread(fid, 'uint32') + 1;
fclose(fid);
%% evolution of rate
%inbump
times_bump = times(ids>=20000 & ids <=21000 );
times_outbump = times(ids<=40000 & (ids < 20000 | ids>21000) );
bump_pop = 1000 ; % should we ignore silent neurons ?
outbump_pop = 39000;
bin_size = 0.05; % s
min_time = min(times_bump);
max_time = max(times_bump);
time_bins = min_time:bin_size:max_time;

% Calculate the activity rate for each bin
bump_rate_evo = zeros(length(time_bins)-1, 1);
for i = 1:length(time_bins)-1
    % Count spikes in this bin
    spikes_in_bin= times_bump >= time_bins(i) & times_bump < time_bins(i+1);
    num_spikes = sum(spikes_in_bin);
    %activity rate
    bump_rate_evo(i) = (num_spikes / (bin_size*bump_pop)); % *100 to get rate in seconds
end
% Create a vector  - center of each bin
bin_centers = time_bins(1:end-1) + bin_size/2;

%outbump

min_time = min(times_outbump);
max_time = max(times_outbump);
time_bins = min_time:bin_size:max_time;
% Calculate the activity rate for each bin
outbump_rate_evo = zeros(length(time_bins)-1, 1);
for i = 1:length(time_bins)-1
    % Count spikes in this bin
    spikes_in_bin= times_outbump >= time_bins(i) & times_outbump < time_bins(i+1);
    num_spikes = sum(spikes_in_bin);
    %activity rate
    outbump_rate_evo(i) = (num_spikes / (bin_size*outbump_pop))*10;% *100 to get rate in seconds
end
% Create a vector  - center of each bin
bin_centers_out = time_bins(1:end-1) + bin_size/2;


%% Rate per cluster
tot_rate=zeros(1,40);
for i=1:40
clust=[(i-1)*1000+1,i*1000+1];
tot_rate(i) = (length(times(ids>clust(1) & ids<clust(2) & times)))/2000;
end

[heights,centers] = hist(tot_rate);
hold on
ax = gca;
ax.XTickLabel = [];
n = length(centers);
w = centers(2)-centers(1);
t = linspace(centers(1)-w/2,centers(end)+w/2,n+1);
p = fix(n/2);
fill(t([p p p+1 p+1]),[0 heights([p p]),0],'w')
plot(centers([p p]),[0 heights(p)],'r:')
h = text(centers(p)-.2,heights(p)/2,'   h');
dep = -70;
tL = text(t(p),dep,'L');
tR = text(t(p+1),dep,'R');
hold off

%% PLOTTING
figure('Position', get(0, 'ScreenSize'),'Color', 'w')
subplot('Position', [0.1 0.82 0.7 0.1245]);
plot ( times(ids>40000), ids(ids>40000)-4e4, 'b.', 'MarkerSize',2 );
ylabel('Inhibitory','Fontsize',15);
set(gca,'TickDir','out','Fontsize',15, 'LineWidth', 1.8,'FontWeight','bold','xticklabel',[],'TickLength',[0.005 0.005])
box off
ax=gca;
ax.YAxis.Exponent = 4;
yticks([0 1e4])

subplot('Position', [0.1 0.25 0.7 0.52]);
plot ( times(ids<40000), ids(ids<40000), 'r.', 'MarkerSize',2); ylabel('Neuron id#');hold on;
fill([1 2 2 1], [20000 20000 21000 21000], [0.5 0.5 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
box off
set(gca,'TickDir','out','Fontsize',15,'LineWidth', 1.8,'FontWeight', 'bold','TickLength',[0.005 0.005])
ylabel('Excitatory','Fontsize',15);
yticks([0 1e4 2e4 3e4 4e4])
annotation('arrow',[0.32,0.33],[0.575 0.575])
line([1 1],[500 40000],'LineStyle', '--','Color','k')
line([2 2],[500 40000],'LineStyle', '--','Color','k')

% 
subplot('Position', [0.1 0.10 0.7 0.10]);
plot(bin_centers, bump_rate_evo,  'LineWidth', 2,'Color',[0.4078 0.7411 0]);
hold on
plot(bin_centers_out, outbump_rate_evo,  'LineWidth', 2);
% fill([1 2 2 1], [0 0 25 25], [0.5 0.5 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
yticks([0 5 10 15 20 25])
set(gca,'TickDir','out','Fontsize',15,'LineWidth', 1.8,'FontWeight', 'bold','TickLength',[0.005 0.005])
box off
xlabel("Time(s)")
ylabel("Rate (sp/s)")
legend("Stimulated cluster","Non-stimulated clusters","Sensory stimulus",'Position', [.82, 0.15, .12, .1],'FontSize', 10)
legend boxoff

% 
% subplot('Position', [0.81 0.36 0.1 0.42]);
% barh(tot_rate, 'EdgeColor', 'none','BarWidth', 1,'FaceColor',[0.5 0.5 0.5])
% box off
% set(gca,'TickDir','out','Fontsize',15,'LineWidth', 1.8,'FontWeight', 'bold','ytick',[],'XTick',[1 4 6 8 10 12],'Xticklabel',{'1', '', '', '', '', '12'},'XTickLabelRotation', 0,'TickLength',[0.005 0.005])
% 


