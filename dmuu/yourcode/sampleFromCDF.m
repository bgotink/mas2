function [index] = sampleFromCDF(CDF)
% returns an index according to the given cummulative distribution
% function.
%
% NOTE: the given argument should be a cdf format!
%
% input:
%   CDF     -   the cummulative distribution function to sample.
%
% output:
%   index   -   the index sampled according to the given CDF.

index = min(find(CDF>=rand(1)));

end

