% ARC MATLAB cluster configuration setting
configCluster;
c = parcluster;
c.AdditionalProperties.AccountName = 'polya';
c.AdditionalProperties.WallTime='48:00:00';
 
