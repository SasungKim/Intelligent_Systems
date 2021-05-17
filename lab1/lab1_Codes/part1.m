function [versi,setosa] = part1(x)
setosa_count = 0;
versi_count = 0;
sum = 0;
for i = 1:150 %CLASSIFYING THE SEPAL WIDTH 
    sum = x(i,2) + sum;
end
avg = sum/150;
thresh = 3.1135
for j = 1:150
    if x(j,2) < thresh
        setosa(j) = x(j,2);    %Identify as Iris Setosa and store it in an array and increment the count
        %versi(j) = 0;           %If greater than average, the element becomes 0 in versi matrix
        setosa_count = setosa_count + 1;
    elseif x(j,2) >= thresh
        versi(j) = x(j,2);     %Identify as Iris Versicolour and store it in an array and increment the count
        %setosa(j) = 0;          %If less than average, the element becomes 0 in setosa matrix
        versi_count = versi_count + 1;
    end
end
setosa(setosa == 0) = [];   %eliminate excess 0s from the array
versi(versi == 0) = [];     %eliminate excess 0s from the array
end