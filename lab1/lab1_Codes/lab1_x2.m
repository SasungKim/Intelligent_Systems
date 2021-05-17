%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ELE 888/ EE 8209: LAB 1: Bayesian Decision Theory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: This script is used for classifying according to
%              Sepal Width
function [posteriors_x,g_x,g_x2]=lab1_x2(x,Training_Data)

% x = individual sample to be tested (to identify its probable class label)
% featureOfInterest = index of relevant feature (column) in Training_Data 
% Train_Data = Matrix containing the training samples and numeric class labels
% posterior_x  = Posterioclr probabilities
% g_x = value of the discriminant function

D=Training_Data;

% D is MxN (M samples, N columns = N-1 features + 1 label)
[M,N]=size(D);    
 
f=D(:,2);  % feature samples (all rows, column 1: sepal length)
la=D(:,N); % class labels (column 5 (1 or 2))


%% %%%%Prior Probabilities%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hint: use the commands "find" and "length"

disp('Prior probabilities:');
class1_count= sum(la(:)==1);
class2_count= sum(la(:)==2);
total_count= length(la);
Pr1 = class1_count/total_count
Pr2 = class2_count/total_count

%% %%%%%Class-conditional probabilities%%%%%%%%%%%%%%%%%%%%%%%

disp('Mean & Std for class 1 & 2');
m11 =  mean(D(1:class1_count,2)) % mean of the class conditional density p(x/w1)
std11 = std(D(1:class1_count,2)) % Standard deviation of the class conditional density p(x/w1)

m12 = mean(D(class1_count+1:total_count,2)) % mean of the class conditional density p(x/w2)
std12= std(D(class1_count+1:total_count,2)) % Standard deviation of the class conditional density p(x/w2)


disp(['Conditional probabilities for x=' num2str(x)]);
cp11= (1/(sqrt(2*pi))*(std11))*(exp((-0.5)*(((x-m11)/std11).^2))) % use the above mean, std and the test feature to calculate p(x/w1)

cp12= (1/(sqrt(2*pi))*(std12))*(exp((-0.5)*(((x-m12)/std12).^2))) % use the above mean, std and the test feature to calculate p(x/w2)

%% %%%%%%Compute the posterior probabilities%%%%%%%%%%%%%%%%%%%%

disp('Posterior prob. for the test feature');

p_x= (cp11*Pr1)+(cp12*Pr2); % p(x) from Bayes Formula

pos11= (cp11*Pr1)/p_x; % p(w1/x) for the given test feature value

pos12= (cp12*Pr2)/p_x; % p(w2/x) for the given test feature value

posteriors_x= [pos11,pos12]

%% %%%%%%Discriminant function for min error rate classifier%%%

disp('Discriminant function for the test feature');
g_x= pos11-pos12
g_x2= pos11 > pos12; % compute the g(x) for min err rate classifier.
                    % Decide w_i if g(x) > 0 [check sign]

