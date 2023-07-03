% batch_run_toy_model.m

clear;

tStart = tic;
% hyper parameter for batch run
batch_size = 10;


% construct the toy models
toy_model_1 = bbModel(@ToyModel_1,3,2,'OutputType',[1 1]);
toy_model_2 = bbModel(@ToyModel_2,3,2,'OutputType',[1 1]);
toy_model_3 = bbModel(@ToyModel_3,3,2,'OutputType',[1 1]);
toy_model_4 = bbModel(@ToyModel_4,10,2,'OutputType',[1 1]);

% construct parameter distribution
uni_pd = makedist('Uniform','lower',0,'upper',2*pi);

params_1 = repmat({uni_pd},3,1); % Toy Model 1-3
params_2 = repmat({uni_pd},10,1);  % Toy Model 4

% batch run
input_number = toy_model_1.ParNumber;
output_number = toy_model_1.OutputNumber;

S1_batch = zeros(batch_size,output_number,input_number);
ST_batch = zeros(batch_size,output_number,input_number);

f = waitbar(0,'Start batch running ...');

for i=1:batch_size
    % update waitbar
    waitbar(i/batch_size, f, sprintf('Progress: %d %%', floor(i/batch_size*100)));
   
    
    [S1, ST] = CircularSobol(toy_model_1, params_1,'method','nonCircular','SampleSize',10^5,'formula',1,...
                                                            'GroupNumber',4,'GroupSize',4,'plot',0,'progress',0);
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
