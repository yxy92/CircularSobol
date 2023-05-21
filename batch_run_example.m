input_number = 10;
batch_size = 10;

%% 10 Batch Run of linear model 1
S1_batch = zeros(batch_size,input_number);
ST_batch = zeros(batch_size,input_number);

for i=1:batch_size
    [S1,ST] = Sobol_solver(@ToyModel_4,pd_list,10,1,1,'circular',2);
    S1_batch(i,:) = S1;
    ST_batch(i,:) = ST;
end

%% mean and error bar

mean_S1 = mean(S1_batch);
std_S1 = std(S1_batch);

mean_ST = mean(ST_batch);
std_ST = std(ST_batch);

% error is so small to ignore

%% plot

%plot_matrix = [S1_plot;ST_plot]';
mean_matrix = [mean_S1;mean_ST]';
figure;
b = bar(mean_matrix,'grouped');



%% plot error bar
error_matrix = [std_S1;std_ST]';

hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(mean_matrix);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, mean_matrix(:,i), error_matrix(:,i), 'k', 'linestyle', 'none','LineWidth',1);
end
hold off

ylim([0 1])
legend('Single','Total')
legend boxoff
yticks(0:.5:1)
set(gca,'FontSize',20)
set(gca,'LineWidth',2)