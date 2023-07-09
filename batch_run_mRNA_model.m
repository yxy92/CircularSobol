% batch_run_mRNA_model.m
% batch run for sobol indices 

clear;
tStart = tic;
% hyper parameter for batch run
batch_size = 10;

% construct the Sarah_Rhythmic_mRNA model
Rhythmic_mRNA_model = bbModel(@Sarah_Rhythmic_mRNA,5,3,'OutputType',[0 0 0]);

% create parameter distribution
par_size = 10000;

amp_pd = makedist('Uniform','lower',0,'upper',1);
phase_pd = makedist('Uniform','lower',0,'upper',24);

Kd_pd_log= makedist('Uniform','lower',-1.58,'upper',1.415);
Kd_pd = 10.^random(Kd_pd_log,[par_size,1]);

params = {amp_pd phase_pd Kd_pd amp_pd phase_pd};

% batch run
input_number = Rhythmic_mRNA_model.ParNumber;
output_number = Rhythmic_mRNA_model.OutputNumber;

S1_batch = zeros(batch_size,output_number,input_number);
ST_batch = zeros(batch_size,output_number,input_number);

f = waitbar(0,'Start batch running ...');

for i=1:batch_size
    % update waitbar
    waitbar(i/batch_size, f, sprintf('Progress: %d %%', floor(i/batch_size*100)));
   
    
    [S1, ST] = CircularSobol(Rhythmic_mRNA_model, params,'method','Circular','SampleSize',10^4,'formula',1,...
                                                            'GroupNumber',100,'GroupSize',100,'plot',0,'progress',0);
    S1_batch(i,:,:) = S1;
    ST_batch(i,:,:) = ST;
    
    fprintf('Finished running the batch %d \n',i);
end

close(f); % close wait bar

% calculate mean and std 
mean_S1 = mean(S1_batch);
std_S1 = std(S1_batch);

mean_ST = mean(ST_batch);
std_ST = std(ST_batch);

%plot_matrix = [S1_plot;ST_plot]';
mean_matrix = [mean_S1;mean_ST];
error_matrix = [std_S1;std_ST];

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

tEnd = toc(tStart);
fprintf('The running took %s \n', duration([0, 0, tEnd]));