clear;

x1 = [-1 -1 1 1];
x2 = [-1 1 -1 1];
tk = [-1 1 1 -1];

n = 0.1;
theta = 0.001;
epoch = 0;
n_input = 2;

% start with random number so it doesn't output 0 forever
w_ji = rand(2,3);
w_kj = rand(1,3);

% To get same result everytime (for testing)
%w_ji = [0.6 -0.3 -0.2; 0.2 0.4 1.5];
%w_kj = [-0.9 0.2 1.1];

while true
    epoch = epoch + 1;
    
    % three inputs (w0, w1, w2), two outputs(yj(1), yj(2))
    delta_wji = zeros(2,3);
    % three inputs (w0, w1, w2), one output(zk)
    delta_wkj = zeros(1,3);
    
    for m = 1:length(x1)
        input = [1 x1(m) x2(m)];
        
        for i = 1:n_input
            netj(i) = w_ji(i, :) * input';
            y(i) = tanh(netj(i));
        end
        yj = [1 y];
        
        for i = 1:n_input
            y_der(i)=1-(y(i))^2;
        end

        netk = yj * w_kj';
        zk(m) = tanh(netk);
        
        zkprime=1-zk(m)^2;

        delta_k = (tk(m) - zk(m))*zkprime;
        
        %delta_j = zeros(1,2);
        for i = 1:n_input
            delta_j(i) = y_der(i)* w_kj(i+1) * delta_k;
        end
        
        for i = 1:n_input
            delta_wji(i, :) = delta_wji(i, :) + n * delta_j(i)*input;
        end
        
        delta_wkj = delta_wkj + n * delta_k * yj;
    end
    
    for i = 1:n_input
        w_ji(i, :) = w_ji(i, :) + delta_wji(i, :);
    end
        w_kj = w_kj + delta_wkj;
        
        J(epoch) = 0.5 * norm(tk-zk)^2; 
        
        if (epoch == 1)
            tot_J = J(epoch);
        else
            tot_J = J(epoch-1) - J(epoch);
        end
        
        %tot_J = abs(tot_J)
        if tot_J < theta
            break
        end
end

% Boundary
figure(1);
title('Boundary');
axis ([-2 2 -2 2])
hold on;
plot(x1(:,1:3:4),x2(:,1:3:4),'mo');
plot(x1(:,2:3),x2(:,2:3),'ks');
plotpc(w_ji(1,2:3), w_ji(1,1))
plotpc(w_ji(2,2:3), w_ji(2,1))


% Learning curve
figure(2);
plot(J);
title('Learning Curve');

% # of epoch
epoch

% Accuracy
score = 0;
for i = 1:length(x1)
    if ((zk(i) < 0 && tk(i) == -1) || (zk(i) > 0 && tk(i) == 1))
        score = score + 1;
    end
end
acc = (score/length(x1)) * 100
