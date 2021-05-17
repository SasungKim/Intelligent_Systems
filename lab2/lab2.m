%% Question 1

% With dataset A and B, features x2 and x3, 30% training and 70% testing

load('irisdata.mat')

a = [0 0 1];
XA = irisdata_features(1:50, 2:3);
XB = irisdata_features(51:100, 2:3);
XC = irisdata_features(101:150, 2:3);

n = 0.01;
threshold = 0;

% Swap 30% Train and 70% Test to 70% Train and 30% Test
train_rate = 0.3;
test_rate = 1 - train_rate;

% Question 1
sizew1 = size(XA, 1);
sizew1_train = int64(train_rate*sizew1);
sizew1_test = int64(test_rate*sizew1);
sizew2 = size(XB, 1);
sizew2_train = int64(train_rate*sizew2);
sizew2_test = int64(test_rate*sizew2);

totalsize = sizew1+sizew2;
totalsize_train = int64(train_rate*totalsize);
totalsize_test = int64(test_rate*totalsize);

% dataset x1 has all positive value and negate x2
y_test = repmat(1, totalsize_test, 3);
y_test(1:sizew1_test, 2:3) = XA(1:sizew1_test, :);
y_test(sizew1_test+1:totalsize_test, 2:3) =  XB(1:sizew2_test, :);

y_train = repmat(1, totalsize_train, 3);
y_train(1:sizew1_train, 2:3) = XA(1:sizew1_train, :);
y_train(sizew1_train+1:totalsize_train, 1) = -1*y_train(sizew1_train+1:totalsize_train, 1);
y_train(sizew1_train+1:totalsize_train, 2:3) =  -1*XB(1:sizew2_train, :);

y_train = y_train.';
y_test = y_test.';
J = 0;
counter = 0;

for iteration = 1:300
    aY = a*y_train;
    hold on;
    % Delta J
    for i = 1:totalsize_train
        if aY(1, i) <= 0
            J = J - y_train(:, i)
        end
    end
    
    if abs(n*J) <= threshold
        break
    else
        a = a - n*J.';
        
        J=0;
        counter = counter + 1;
    end
end

figure;

for i = 1:sizew1*train_rate
    plot(XA(i,1),XA(i,2),'marker', 'o', 'color', 'blue', 'DisplayName', 'Iris-Setosa')
    hold on;
end


for i = 1:sizew2*train_rate
    plot(XB(i,1),XB(i,2),'marker', 'x', 'color', 'red', 'DisplayName', 'Iris-Versicolor')
    hold on;
end

x=0:5;

plot(x,(-1*a(2)/a(3))*x-a(1)/a(3))

fprintf("# of iteration: %d\n", counter)

xlabel('sepal width')
ylabel('petal length')
title('o - Iris-Setosa | x - Iris-Versicolor | train = 70%')

hold off;

% discriminant function
g_w = a*y_test;
%{
for i = 1:totalsize_test
    g_w(i);
    fprintf("sample: %d - ", i)
    if(g_w(i) >= 0)
        disp("Iris-setosa")
    else
        disp("Iris-versicolor")
    end
end
%}

% Accuracy Test

XA_test = repmat(1, sizew1_test, 3);
XA_test(1:sizew1_test, 2:3) = XA(1:sizew1_test, :);

g_wa = a * XA_test';

disp ("Accuracy on class Iris-Setosa: ")
% (total # of sample - samples with error) / total # of sample
g_wa_acc = (length(g_wa) - sum(g_wa(:) < 0))/ length(g_wa)

XB_test = repmat(1, sizew2_test, 3);
XB_test(1:sizew2_test, 2:3) = XB(1:sizew2_test, :);

g_wb = a * XB_test';

disp ("Accuracy on class Iris-Versicolor: ")
% (total # of sample - samples with error) / total # of sample
g_wb_acc = (length(g_wb) - sum(g_wb(:) > 0))/ length(g_wb)

%% Question 4

% With dataset B and C, features x2 and x3, 30% training and 70% testing

sizew1 = size(XB, 1);
sizew1_train = int64(train_rate*sizew1);
sizew1_test = int64(test_rate*sizew1);
sizew2 = size(XC, 1);
sizew2_train = int64(train_rate*sizew2);
sizew2_test = int64(test_rate*sizew2);

totalsize = sizew1+sizew2;
totalsize_train = int64(train_rate*totalsize);
totalsize_test = int64(test_rate*totalsize);


% dataset x1 has all positive value and negate x2
y_test = repmat(1, totalsize_test, 3);
y_test(1:sizew1_test, 2:3) = XB(1:sizew1_test, :);
y_test(sizew1_test+1:totalsize_test, 2:3) =  1*XC(1:sizew2_test, :);

y_train = repmat(1, totalsize_train, 3);
y_train(1:sizew1_train, 2:3) = XB(1:sizew1_train, :);
y_train(sizew1_train+1:totalsize_train, 1) = -1*y_train(sizew1_train+1:totalsize_train, 1);
y_train(sizew1_train+1:totalsize_train, 2:3) =  -1*XC(1:sizew2_train, :);

y_train = y_train.';
y_test = y_test.';
J = 0;
counter = 0;

for iteration = 1:300
    aY = a*y_train;
    %plot(x,(-1*a(2)/a(3))*x-a(1)/a(3))
    hold on;
    
    % Delta J
    for i = 1:totalsize_train
        if aY(1, i) <= 0
            J = J - y_train(:, i);
        end
    end
    
    if abs(n*J) <= threshold
        break
    else
        a = a - n*J.';
        J=0;
        counter = counter + 1;
    end
end

figure;
for i = 1:sizew1*train_rate
    plot(XB(i,1),XB(i,2),'marker', 'o', 'color', 'blue', 'DisplayName', 'Iris-Versicolor')
    hold on;
end


for i = 1:sizew2*train_rate
    plot(XC(i,1),XC(i,2),'marker', 'x', 'color', 'red', 'DisplayName', 'Iris-Virginia')
    hold on;
end

x=0:5;


plot(x,(-1*a(2)/a(3))*x-a(1)/a(3))

fprintf("# of iteration: %d\n", counter)
xlabel('sepal width')
ylabel('petal length')
title('o - Iris-Versicolor | x - Iris-Verginia | train = 70%')

hold off;


% discriminant function
g_w = a*y_test;
%{
for i = 1:totalsize_test
    g_w(i);
    fprintf("sample: %d - ", i)
    if(g_w(i) >= 0)
        disp("Iris-Versicolor")
    else
        disp("Iris-Verginia")
    end
end
%}

% Accuracy test

XB_test = repmat(1, sizew1_test, 3);
XB_test(1:sizew1_test, 2:3) = XB(1:sizew1_test, :);

g_wb = a * XB_test';

disp ("Accuracy on class Iris-Versicolor: ")
% (total # of sample - samples with error) / total # of sample
g_wb_acc = (length(g_wb) - sum(g_wb(:) < 0))/ length(g_wb)

XC_test = repmat(1, sizew2_test, 3);
XC_test(1:sizew2_test, 2:3) = XC(1:sizew2_test, :);

g_wc = a * XC_test';

disp ("Accuracy on class Iris-Verginia: ")
% (total # of sample - samples with error) / total # of sample
g_wc_acc = (length(g_wc) - sum(g_wc(:) > 0))/ length(g_wc)
