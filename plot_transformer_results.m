clear
close all

load /Users/huanglong/targets.mat
load /Users/huanglong/predictions.mat

%% fragment length
fs = 1000;
fragment_length = 100;
result_fs = fs/fragment_length;

folderName = '/Volumes/Extreme_SSD/mvts_transformer/dataset/ten_tasks_contact_free_dataset/attack_at_beginning_and_halfway_hijacking/user1_legitimate/';
files = dir(strcat(folderName,'test*'));
numberOfTestInstances = size(files,1);
instanceIndexes = zeros(numberOfTestInstances,2);
for i = 1:numberOfTestInstances
    instanceLength = floor(size(load(strcat(folderName,'test',num2str(i),'.mat')).data,1)/fragment_length);
    if i == 1
        instanceIndexes(i,1) = 1;
        instanceIndexes(i,2) = instanceLength;
    else
        instanceIndexes(i,1) = instanceIndexes(i-1,2)+1;
        instanceIndexes(i,2) = instanceIndexes(i-1,2)+instanceLength;
    end
end

targets_integrated = [];
predictions_integrated = [];

%% observation window length
windowLength = 30;

for i = 1:numberOfTestInstances
    targets_instance = targets(instanceIndexes(i,1):instanceIndexes(i,2));
    predictions_instance = predictions(instanceIndexes(i,1):instanceIndexes(i,2));
    
    targets_instance_integrated = zeros(1,length(targets_instance)-windowLength+1);
    predictions_instance_integrated = zeros(1,length(predictions_instance)-windowLength+1);
    
    for j = 1:length(targets_instance)-windowLength+1
        targets_instance_integrated(j) = mode(targets_instance(j:j+windowLength-1));
        predictions_instance_integrated(j) = mode(predictions_instance(j:j+windowLength-1));
    end
    
    if i <= 5
        figure;hold on;box on;
        plot((1:length(targets_instance_integrated))/result_fs,targets_instance_integrated,'-o','linewidth',1,'markersize',7);
        plot((1:length(predictions_instance_integrated))/result_fs,predictions_instance_integrated,'-^','linewidth',1,'markersize',5);
        
%         xlim([0 25]);
        ylim([-0.5 1.5]);
        yticks(0:1);
        xlabel('Time (s)');
        ylabel('Label');
        legend({'Target','Prediction'})
        set(gca,'FontWeight', 'bold','FontSize', 24,'Linewidth',2);
    end
    
    targets_integrated = [targets_integrated targets_instance_integrated];
    predictions_integrated = [predictions_integrated predictions_instance_integrated];
end

accuracy = mean(double(targets_integrated)==double(predictions_integrated))
figure;confusionchart(double(targets_integrated),double(predictions_integrated),'normalization','row-normalized');