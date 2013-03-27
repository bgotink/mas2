function [] = testSampleFromCDF( )


CDF = [1 2 3 4 5 6 7 8 9 10];
CDF = CDF/ sum(CDF);

result = zeros(1,10);

for i=1:100000
    index = sampleFromCDF(CDF);
    result(1,index) = result(1,index)+1;
end

plot(result/100000)


end

