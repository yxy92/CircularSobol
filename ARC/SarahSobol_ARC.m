% SarahSobol_batch_ARC.m
% Circular Sobol indices for a model of rhythmic mRNA expression by Sarah Luck et al. 2012


function [S1, ST] = SarahSobol_ARC(fname)

% construct the Sarah_Rhythmic_mRNA model
Rhythmic_mRNA_model = bbModel(@Sarah_Rhythmic_mRNA,5,3,'OutputType',[0 0 0]);

% create parameter distribution
N = 10000;

amp_pd = makedist('Uniform','lower',0,'upper',1);
phase_pd = makedist('Uniform','lower',0,'upper',24);

Kd_pd_log= makedist('Uniform','lower',-1.58,'upper',1.415);
Kd_pd = 10.^random(Kd_pd_log,[N,1]);

params = {amp_pd phase_pd Kd_pd amp_pd phase_pd};


% call CircularSobol
method = 'Nested';
SampleSize = 10^3;
formula = 1;
GroupNumber = 10^3;
GroupSize = 2;

[S1, ST] = CircularSobol(Rhythmic_mRNA_model, params,'method',method,'SampleSize',SampleSize,'formula',formula,...
                                                            'GroupNumber',GroupNumber,'GroupSize',GroupSize);
                                                        
% write S1, ST to output
save(fname);

end