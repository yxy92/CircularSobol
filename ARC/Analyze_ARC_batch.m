% Analyze_ARC_batch.m

clear;
% set up input directory relative path

%input_dir = "ARC_Output.dir\SarahSobol_ARC_batch\Nested_nonCirc_Formula_1.dir\";

input_dir = "ARC_Output.dir\SarahSobol_ARC_batch\Nested_nonCirc_Formula_2_SampleSize_5.dir\";

% load mat file
fileList = dir(input_dir+'\*.mat');
fileList = {fileList.name};

fileNumber = length(fileList);

S1_array = cell(fileNumber,1);
ST_array = cell(fileNumber,1);

for i = 1:fileNumber
    currentFile = fileList{i};
    load(input_dir + currentFile);
    
    % save S1 & ST
    S1_array{i} = S1;
    ST_array{i} = ST;
    
    msg = "Finish reading the " + " "+ num2str(i)+ "th file";
    disp(msg);
    
    clear S1;
    clear ST;
    
end


% mean and std

[m,n] = size(S1_array{1});

S1_batch = reshape(cell2mat(S1_array),fileNumber,m,n);
ST_batch = reshape(cell2mat(ST_array),fileNumber,m,n);

% calculate mean and std 
mean_S1 = mean(S1_batch);
std_S1 = std(S1_batch);

mean_ST = mean(ST_batch);
std_ST = std(ST_batch);

%plot_matrix = [S1_plot;ST_plot]';
mean_matrix = [mean_S1;mean_ST];
error_matrix = [std_S1;std_ST];

output_number = m;
input_number = n;

for i=1:output_number
    
    figure;
    tmp_mean = reshape(mean_matrix(:,i,:),[2,input_number])';
    b = bar(tmp_mean,'grouped');

    % plot error bar
    tmp_error = reshape(error_matrix(:,i,:),[2,input_number])';

    hold on;
    % Find the number of groups and the number of bars in each group
    [ngroups,nbars] = size(tmp_mean);
    
    % for R2019a and earlier

    % Calculate the width for each bar group
    groupwidth = min(0.8, nbars/(nbars + 1.5));
    
    % Set the position of each error bar in the centre of the main bar
    for j = 1:nbars
        % Calculate center of each bar
        x = (1:ngroups) - groupwidth/2 + (2*j-1) * groupwidth / (2*nbars);
        errorbar(x, tmp_mean(:,j), tmp_error(:,j), 'k', 'linestyle', 'none');
    end
    
%     % for R2019b and later
%     % Calculate the width for each bar group
%     x_cor = nan(nbars, ngroups);
%     for j = 1:nbars
%         x_cor(j,:) = b(j).XEndPoints;
%     end 
%     % Plot the errorbars
%     errorbar(x_cor',tmp_mean,tmp_error,'k','linestyle','none');
    
    hold off

    ylim([0 1])
    legend('Single','Total')
    legend boxoff
    yticks(0:.5:1)
    set(gca,'FontSize',20)
    set(gca,'LineWidth',2)
end
