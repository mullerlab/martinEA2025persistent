fid = fopen('../data/ring_model/times_inh.txt','r');
times_inh = fscanf(fid, '%f');
fclose(fid);

fid = fopen('../data/ring_model/ids_inh.txt','r');
ids_inh = fscanf(fid, '%f');
fclose(fid);


fid = fopen('../data/ring_model/times.txt','r');
times = fscanf(fid, '%f');
fclose(fid);
fid = fopen('../data/ring_model/ids.txt','r');
ids= fscanf(fid, '%f');
fclose(fid);
t_model = linspace(0,3,60000);

%% Excitatory rates histogram
exc_rates=zeros(1,100);
for i=1:100
clust=[(i-1)*10+1,i*10+1];
exc_rates(i) = (length(times(ids>clust(1) & ids<clust(2) & times)))/20;
end
%% inhibitory rates histogram
inh_rates=zeros(1,100);
for i=1:100
bin_edges=[(i-1)*3+1,i*3+1];
inh_rates(i) = (length(times_inh(ids_inh>bin_edges(1) & ids_inh<bin_edges(2) & times_inh)))/20;
end


%% import conductance data
gaba = readmatrix('./gaba.txt');
ampa = readmatrix('./ampa.txt');
nmda = readmatrix('./nmda.txt');
gaba = gaba(:,2);
ampa = ampa(:,2);
nmda = nmda(:,2);

%%
fid = fopen('../data/ring_model/voltage_sample.txt','r');
voltage_model_neuron = fscanf(fid, '%f');
fclose(fid);

spike_times_neuron_model = times(ids == 571);
for i = 1:length(spike_times_neuron_model )
voltage_model_neuron(floor(spike_times_neuron_model (i)*20))=20;
end


%% import network clamp data
[data,si,header]=abfload('../data/ring_model/25606017.abf');
num_points = header.dataPtsPerChan;
sampling_rate = header.fADCSampleInterval * 1e-6; % in microseconds
t_net_clamp = linspace(0, (num_points - 1) * sampling_rate*2, num_points);





%% PLOTTING
%raster
figure('Position', get(0, 'ScreenSize'),'Color', 'w')
subplot('Position', [0.1 0.82 0.7 0.15]);
plot ( times_inh/1000, ids_inh, 'b.', 'MarkerSize',8 );
ylabel('Inhibitory','Fontsize',15);
set(gca,'TickDir','out','Fontsize',20, 'LineWidth', 3,'FontWeight','bold','xticklabel',[],'TickLength',[0.005 0.005])
box off


subplot('Position', [0.1 0.36 0.7 0.42]);
plot ( times/1000, ids, 'r.', 'MarkerSize',8);hold on;
fill([.2 .2 .4 .4], [512 512 640 640], [0.5 0.5 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
box off
set(gca,'TickDir','out','Fontsize',20,'LineWidth', 3,'FontWeight', 'bold','TickLength',[0.005 0.005])
ylabel('Excitatory','Fontsize',20);
ylim([0 1024])

%smoothed histogram
subplot('Position', [0.81 0.36 0.1 0.42]);
area(smooth(exc_rates,20),'FaceColor','r', 'EdgeColor', 'none');set(gca,'YAxisLocation','right','XDir','reverse');camroll(-90);
box off
set(gca,'TickDir','out','Fontsize',20,'LineWidth', 3,'FontWeight', 'bold',['xtick'],[],'yTick',[1 5 10 15 20],'yticklabel',{'1', '', '', '', '20'},'yTickLabelRotation', 0,'TickLength',[0.005 0.005])
ylim([0 22])

subplot('Position', [0.81 0.82 0.1 0.15]);
area(smooth(inh_rates,20), 'EdgeColor', 'none');set(gca,'YAxisLocation','right','XDir','reverse');camroll(-90);
box off
set(gca,'TickDir','out','Fontsize',20,'LineWidth', 3,'FontWeight', 'bold',['xtick'],[],'yTick',[1 5 10 15 20],'yticklabel',{'1', '', '', '', '20'},'yTickLabelRotation', 0,'TickLength',[0.005 0.005])
ylim([0 22])
xlim([0 86])


% traces
subplot("Position",[0.1 0.2 0.7 0.1])
plot(t_model.',voltage_model_neuron)
box off
set(gca,'TickDir','out','Fontsize',20,'LineWidth', 3,'FontWeight', 'bold','TickLength',[0.005 0.005])

subplot("Position",[0.1 0.1 0.7 0.1])
plot(t_model.',gaba);hold on; plot(t_model.',ampa); plot(t_model.',nmda)
box off
set(gca,'TickDir','out','Fontsize',20,'LineWidth', 3,'FontWeight', 'bold','TickLength',[0.005 0.005])
