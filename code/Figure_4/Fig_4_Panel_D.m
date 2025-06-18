f=load("naive_vs_dopamine.mat");
rate=[];
stim=[];
warning('off','signal:findpeaks:largeMinPeakHeight');
for i = 1:length(f)
[data,si,header]=abfload(f{i,1});
num_points = header.sweepLengthInPts;
sampling_rate = header.fADCSampleInterval * 1e-6; % in microseconds
t = linspace(0, (num_points - 1) * sampling_rate, num_points);

initial_stim = header.DACEpoch.fEpochInitLevel(4);
step = header.DACEpoch.fEpochLevelInc(4);
% plot FI curve
    rate_i=[];
    stim_i=[];
    flag=false;
for sweep = 1:header.lActualEpisodes
    %[pks,locs] = spike_times(data(:,1,sweep),0);
    [pks,locs] = findpeaks(data(:,1,sweep), t, 'MinPeakHeight',0,'MinPeakDistance',0.002);
    if pks ~= 0
    rate_i = [rate_i;length(pks)];
    stim_i = [stim_i ; initial_stim+sweep*step];
    end
    
    if ~flag && numel(pks) ~= 0 % keep track of the first sweep to have a spike
        rheobase = sweep;
        flag=true;
    end
end
rate(i,1:length(rate_i))=rate_i.';
stim(i,1:length(stim_i))=stim_i.';
end


%%
FI_interp_1=interp1(stim(1, stim(1,:)~=0),rate(1, rate(1,:)~=0),[140,160,180,220,260,300,340,380,420], 'linear', 'extrap');% 23_08_cell3
FI_interp_2=interp1(stim(2,stim(2,:)~=0),rate(2, rate(2,:)~=0),[140,160,180,220,260,300,340,380,420], 'linear', 'extrap'); % 29_08_cell5
FI_interp_3=interp1(stim(3,stim(3,:)~=0),rate(3, rate(3,:)~=0),[140,160,180,220,260,300,340,380,420], 'linear', 'extrap');%14_12_cell1 need to move two to the right on line 2
FI_interp_4=interp1(stim(4,stim(4,:)~=0),rate(4, rate(4,:)~=0),[140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_5=interp1(stim(5,stim(5,:)~=0),rate(5, rate(5,:)~=0),[140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_6=interp1(stim(6,stim(6,:)~=0),rate(6, rate(6,:)~=0),[140,160,180,220,260,300,340,380,420], 'linear', 'extrap');

%%
interp_all=[FI_interp_1;FI_interp_2;FI_interp_3;FI_interp_4;FI_interp_5;FI_interp_6];
interp_all_mean=mean(interp_all);
SEM = std(interp_all)/sqrt(length(interp_all));
figure;plot([140,160,180,220,260,300,340,380,420],interp_all_mean)
hold on;errorbar([140,160,180,220,260,300,340,380,420], interp_all_mean, SEM, 'LineWidth', 1.5);
%% DOPAMINE
rate=[];
stim=[];
warning('off','signal:findpeaks:largeMinPeakHeight');
for i = 1:length(f)
[data,si,header]=abfload(f{i,2});
num_points = header.sweepLengthInPts;
sampling_rate = header.fADCSampleInterval * 1e-6; % in microseconds
t = linspace(0, (num_points - 1) * sampling_rate, num_points);

initial_stim = header.DACEpoch.fEpochInitLevel(4);
step = header.DACEpoch.fEpochLevelInc(4);
% plot FI curve
    rate_i=[];
    stim_i=[];
    flag=false;
for sweep = 1:header.lActualEpisodes
    %[pks,locs] = spike_times(data(:,1,sweep),0);
    [pks,locs] = findpeaks(data(:,1,sweep), t, 'MinPeakHeight',0,'MinPeakDistance',0.002);
    if pks ~= 0
    rate_i = [rate_i;length(pks)];
    stim_i = [stim_i ; initial_stim+sweep*step];
    end
    
    if ~flag && numel(pks) ~= 0 % keep track of the first sweep to have a spike
        rheobase = sweep;
        flag=true;
    end
end
rate(i,1:length(rate_i))=rate_i.';
stim(i,1:length(stim_i))=stim_i.';
end
%%
interp_all_dopa=[];
FI_interp_7=interp1(stim(1, stim(1,:)~=0),rate(1, rate(1,:)~=0),[120,140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_8=interp1(stim(2,stim(2,:)~=0),rate(2, rate(2,:)~=0),[120,140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_9=interp1(stim(3,stim(3,:)~=0),rate(3, rate(3,:)~=0),[120,140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_10=interp1(stim(4,stim(4,:)~=0),rate(4, rate(4,:)~=0),[120,140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_11=interp1(stim(5,stim(4,:)~=0),rate(5, rate(5,:)~=0),[120,140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
FI_interp_12=interp1(stim(6,stim(6,:)~=0),rate(6, rate(6,:)~=0),[120,140,160,180,220,260,300,340,380,420], 'linear', 'extrap');
%%
interp_all_dopa=[FI_interp_7;FI_interp_8;FI_interp_9;FI_interp_10;FI_interp_11;FI_interp_12];
interp_all_dopa_mean=mean(interp_all_dopa);
SEM_dopa = std(interp_all_dopa)/sqrt(length(interp_all_dopa));
hold on;plot([120,140,160,180,220,260,300,340,380,420],interp_all_dopa_mean)
hold on;errorbar([120,140,160,180,220,260,300,340,380,420], interp_all_dopa_mean, SEM_dopa, 'LineWidth', 1.5);
