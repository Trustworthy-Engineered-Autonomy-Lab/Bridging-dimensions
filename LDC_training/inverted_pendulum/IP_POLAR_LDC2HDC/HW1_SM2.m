%hw1
%Problem3 (a)
% Number of samples
N = 10^4;

%PartA
N = 10^4;
% Initialize X0
X0 = 0;

% Generate N samples from a Laplace distribution centered at 0
b = 1; % Scale parameter for Laplace distribution
X_rest = laprnd(N-1, 1, 0, b);
Xk = [X0;X_rest];

% Calculate mean and variance
mean_Xk = mean(Xk);
var_Xk = var(Xk);
disp(['Mean of Xk for partA: ', num2str(mean_Xk)]);
disp(['Variance of Xk for partA: ', num2str(var_Xk)]);

%draw the histogram
figure
subplot(2,1,1)
histogram(Xk, 1000)
title('A: Laplace distribution with X0=0')

%Part B
% Initialize X0
% Generate N samples from a Laplace distribution centered at 0
b = 1; % Scale parameter for Laplace distribution
Xk = laprnd(N, 1, 0, b);

% Calculate mean and variance
mean_Xk = mean(Xk);
var_Xk = var(Xk);
disp(['Mean of Xk for PartB: ', num2str(mean_Xk)]);
disp(['Variance of Xk for PartB: ', num2str(var_Xk)]);

%draw the histogram
subplot(2,1,2)
histogram(Xk, 1000)
title('B:Laplace distribution with X0!=0')
function samples = laprnd(N, M, mu, b)
    % Generate N x M Laplace-distributed random samples
    % with mean mu and scale parameter b
    u = rand(N, M) - 0.5;
    samples = mu - b * sign(u) .* log(1 - 2 * abs(u));
end
