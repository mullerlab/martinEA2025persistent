%load("./NC_naive_dopa_dir.mat")
NC_naive_dopa_dir=f_dopamine;
for i =1:4
for j = 1:10
rates_matrix(i,j)=NC_rate(NC_naive_dopa_dir{i,j})
end
end

%% Plotting
figure;
hold on;
for i = 1:4   
    scatter(i, rates_matrix(i,1:5), 100, [0 0 1], 'filled');   
    scatter(i, mean(rates_matrix(i,1:5)), 2000, [0 0 1], '_');
    scatter(i, rates_matrix(i,6:10), 100, [1 0.5 0], 'filled');  
    scatter(i, mean(rates_matrix(i,6:10)), 2000, [1 0.5 0], '_');
end

xlim([0.5 4.5])
xticks([1 2 3 4]);
xticklabels({'10sp/s', '20sp/s', '30sp/s', '40sp/s'});
ylabel("Frequency (sp/s)")
xlabel("Network clamp protocol")

%% Function

function rate= NC_rate(path,start)

if path ~= ""
% import data
[data,si,header]=abfload(path);
num_points = header.dataPtsPerChan;
sampling_rate = header.fADCSampleInterval * 1e-6; % in microseconds
t = linspace(0, (num_points - 1) * sampling_rate*2, num_points);

voltage = data(:,1); % 
stim = data(:,2);


start= t(find(stim>0.04,1))-0.002;

[pks,locs] = findpeaks(voltage, t, 'MinPeakHeight',0,'MinPeakDistance',0.002);
if contains(path,"25_02_05")% files from 25_02_05 missing stimulation ?
start = 1.2;
end
if path == "./25_02_05/25205019.abf"
     start = 3.36720;
end


spike_train = locs(locs>start & locs<start+3);
rate = length(spike_train)/3;
if length(spike_train)>3
isis = diff(spike_train);
mn = mean(isis);
std_ = std(isis);
CVs = std_/mn
if std_/mn == 0
    disp("null")
end

end
end
end

