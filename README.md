# CircularSobol
<span style="color:black;font-weight:200;font-size:20px">
CircularSobol is a computational tool that calculates the circular Sobol indices 
tailored for biological oscillation models.
</span>

## Circular statistics Vs Non-circular statistics
<span style="color:black;font-weight:200;font-size:20px">
Angles by their nature have no maximum nor minimum values, therefore circular mean 
and circular variance are differently defined from their counterpart in 
non-circular statistics.
</span>

<img src="Circular_noncircular_Statistics.png"  width="400" height="400">



## Sobol indices
<span style="color:black;font-weight:200;font-size:20px">
Sobol's method or Sobol indices, is a global sensitivity analysis based on the decomposition of variance 
(orginal paper: I. M. Sobol′, 2001).
</span>

<img src="Sobolindices.png"  width="600" height="600">


## Circular Sobol indices for biological oscillation models
<span style="color:black;font-weight:200;font-size:20px">
CircularSobol combines the parameter sampling scheme from the Monte Carlo estimate algorithms
in the original Sobol's method and the definition of circular variance to more
accurately quantify the contribution of individual parameters to the variance in circular model
output.
</span>