function SobolPlot(S1,ST)
    tmp = size(S1); % S1 is of size m by d, where m = # outputs, d =  # parameters
    OutputNumber = tmp(1);
    % plot single and total Sobol index for each output
    for i=1:OutputNumber
        figure;
        single_index = S1(i,:);
        total_index = ST(i,:);

        plot_matrix = [single_index;total_index]';

        bar(plot_matrix);

        ylim([0 1])
        legend('S','T')
        legend('boxoff')
        yticks(0:.5:1)
        
    end

end