%% 'Wine' Data Set
clear;
load winedata.mat;

x1 = [data(1:59,2); data(131:178, 2)]';
x2 = [data(1:59,3); data(131:178, 3)]';
tk= [ones(59,1);-1*ones(48,1)]';

target_min = -3;
target_max =  3;

data = x1;
x1_min = min(data(:));
x1_max = max(data(:));
x1 = (data - x1_min)*((target_max - target_min)/(x1_max - x1_min)) + target_min;

data = x2;
x2_min = min(data(:));
x2_max = max(data(:));
x2 = (data - x2_min)*((target_max - target_min)/(x2_max - x2_min)) + target_min;

n = 0.1;
theta = 0.001;
epoch = 0;

% start with random number so it doesn't output 0 forever
w_ji=[0.6 -0.3 1]
w_kj=[-0.9 0.2 1]
wk=[1 0.9 -0.7]

while true

    epoch=epoch+1;
    deltaw_ji=[0 0 0];
    deltaw_kj=[0 0 0];
    deltawjk=[0 0 0];
    
    for m=1:length(x1)
        xm=[1 x1(m) x2(m)];
        
        netj1=w_ji*xm';
        netj2=w_kj*xm';
        
        yi_der=1-(tanh(netj1))^2;
        yj_der=1-(tanh(netj2))^2;
        yi=tanh(netj1);
        yj=tanh(netj2);
        
        y=[1 yi yj];
        
        netk=y*wk';        
        zk(m)=tanh(netk);
        zkprime=1-zk(m)^2;
        
        deltak=(tk(m)-zk(m))*zkprime;
        deltaj1=yi_der*wk(2)*deltak;
        deltaj2=yj_der*wk(3)*deltak;

        deltaw_ji=deltaw_ji+n*deltaj1*xm;
        deltaw_kj=deltaw_kj+n*deltaj2*xm;
        deltawjk=deltawjk+n*deltak*y;
    end
    
    w_ji=w_ji+deltaw_ji;
    w_kj=w_kj+deltaw_kj;
    wk=wk+deltawjk;
    
    J(epoch)=0.5*norm(tk-zk)^2;
    
    if (epoch==1)
        delta_j(epoch)=J(epoch);
    else
        delta_j(epoch)=abs(J(epoch-1)-J(epoch));
        if ((delta_j(epoch)<theta) && epoch<100000)
            break;
        end
    end
    
end

% Boundary
figure(1);

x11=(-3:3);
w01=w_ji(1);
w11=w_ji(2);
w21=w_ji(3);
x21=-(w11/w21)*x11-(w01/w21);
plot(x11,x21,'k');

w01=w_kj(1);
w11=w_kj(2);
w21=w_kj(3);
x22=-(w11/w21)*x11-(w01/w21);

hold on;

boundedline=plot(x11,x22,'k');

for i=1:length(x1)
    if (zk(i)<0)
        false=plot(x1(i),x2(i),'mo');
    else
        true=plot(x1(i),x2(i),'ks');
    end
end

title('Boundary');

% Learning curve
figure(2);
plot(J)
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