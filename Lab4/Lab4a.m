clear;

I = imread('house.tiff');
x = reshape(I, 256*256, 3);
x = double(x);

R = [1 0 0]; G = [0 1 0]; B = [0 0 1];

% Distribution of pixels in RGB space
figure;
plot3(x(:,1), x(:,2), x(:,3),'.','Color',[B])

% Initial state (c = 2): [0.1, 0.9] * 256
M = [.1 .1 .1;.9 .9 .9] * 256;
% Initial state (c = 2): random
%M = rand(2, 3) * 256

M_past = zeros(size(M));

J=[];

M1 = M(1,:);
M2 = M(2,:);


% Just for checking number of iterations
counter = 0;

while (M_past ~= M)
    counter = counter + 1;
    M_past = M;
    
    J1 = (x - repmat(M(1,:), length(x), 1));
    J1 = sum(J1.^2, 2);
    J2 = (x - repmat(M(2,:), length(x), 1));
    J2 = sum(J2.^2, 2);
    
    c1 = J1 < J2;
    c2 = ~c1;
    
    M(1,:) = sum(x(c1, :))/sum(c1);
    M(2,:) = sum(x(c2, :))/sum(c2);
    
    J = [J sum(min(J1,J2))];
    M1 = [M1;M(1,:)];
    M2 = [M2;M(2,:)];
    M;
end


% Plot J
figure(1)
plot(J)

% Plot Cluster Means
figure(2)
plot3(M1(:, 1), M1(:, 2), M1(:, 3), '-*')
hold all
plot3(M2(:, 1), M2(:, 2), M2(:, 3), '-*')

% Data Samples in RGB space: faded red = cluster 1, faded blue = cluster 2
x1 = x(c1, :);
x2 = x(c2, :);

figure(3)
plot3(x1(:,1), x1(:,2), x1(:,3),'.','Color', uint8(M(1,:)))
hold all
plot3(x2(:,1), x2(:,2), x2(:,3),'.','Color', uint8(M(2,:)))

% Image
xx = repmat(M(1,:), size(x,1), 1) .* repmat(c1, 1, size(x,2));
xx = xx + repmat(M(2,:), size(x,1), 1) .* repmat(c2, 1, size(x,2));
xx = reshape(xx, size(I, 1), size(I, 2), 3);

figure(4)
subplot(1,2,1);imshow(I)
subplot(1,2,2);imshow(uint8(xx))
