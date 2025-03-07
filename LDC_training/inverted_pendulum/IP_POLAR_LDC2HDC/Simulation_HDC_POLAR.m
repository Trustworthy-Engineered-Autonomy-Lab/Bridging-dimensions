% %% Ground safety/unsafety simulaiton results of HDC.
% %generate the structured data, especially the points in the rectangle.
% theta_interv = 0 : 0.01 : 2;
% dot_interv = -2 : 0.01 : 0;
% num_theta = numel(theta_interv);
% num_dot = numel(dot_interv);
% 
% % Load the HDC
% loaded_HDC = load('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/HDC_POLAR.mat');
% loaded_HDC = loaded_HDC.net;
% 
% global ini_theta_high
% global ini_thetadot_high
% global input3
% ctrl_step  = 30;
% safe_theta_HDC = [];
% safe_dot_HDC = [];
% unsafe_theta_HDC = [];
% unsafe_dot_HDC = [];
% env = rlPredefinedEnv("SimplePendulumWithImage-Continuous");
% 
% theta_end_small = [];
% 
% for i = 1 : num_theta
%     for k = 1 : num_dot
%     
%     init_theta = theta_interv(i);
%     init_dot = dot_interv(k);
%     numP_area= 3;
% 
%     % Generate random x and y coordinates within the specified area
%     xCoordinates = theta_interv(i) + (0.01 * rand(1, numP_area));
%     yCoordinates = dot_interv(k) + (0.01 * rand(1, numP_area));
%     % Combine x and y coordinates into a 2-by-10 matrix
%     points = [xCoordinates; yCoordinates];
% 
% 
%     for j = 1 :numP_area
%     ini_theta_high = points(1,j);
%     ini_thetadot_high = points(2,j);
% %   ini_theta_high = 1.1;
% %   ini_thetadot_high = -0.1;
% 
%     % Simulation for high_dimensional controller
%     counter = 0;
%     observation_test = reset(env);
%     plot(env)
%     done = false;
%     while counter < ctrl_step
%     % Convert observation to dlarray
%     new_input_images = observation_test{1,1};
%     new_input_scalars = observation_test{1,2};
%     dsX1New = arrayDatastore(new_input_images, 'IterationDimension', 4);
%     dsX2New = arrayDatastore(new_input_scalars');
%     dsNewData = combine(dsX1New, dsX2New);
%     action = predict(loaded_HDC, dsNewData); 
%     %action_items = [action_items,action];
%     [observation_test, reward, done, info] = step(env, action);
% 
%     counter = counter + 1;
%     end
%     theta_end_small(j) = input3(end);
%     theta_high_last = input3(end);
%     end
% 
%     %check the safety
%     isInRange = all(theta_end_small >= 0 & theta_end_small <= 0.35);
%     if isInRange
%     disp('Safe in range [0, 0.35].');
%     safe_theta_HDC = [safe_theta_HDC, theta_interv(i)];
%     safe_dot_HDC = [safe_dot_HDC, dot_interv(k)];
%     else
%     disp('Unsafe.');
%     unsafe_theta_HDC = [unsafe_theta_HDC, theta_interv(i)];
%     unsafe_dot_HDC = [unsafe_dot_HDC, dot_interv(k)];
%     end
% 
% 
% 
% 
% %     if  theta_high_last <= 0.35 && theta_high_last >= 0
% %         safe_theta_HDC = [safe_theta_HDC, theta_interv(i)];
% %         safe_dot_HDC = [safe_dot_HDC, dot_interv(k)];
% %     
% %     else
% %         unsafe_theta_HDC = [unsafe_theta_HDC, theta_interv(i)];
% %         unsafe_dot_HDC = [unsafe_dot_HDC, dot_interv(k)];
% %     end
% 
% 
%     fprintf('Finished theta and dot: (%d, %d)\n', i, k);
% 
%     end
% end
% 
% figure
% scatter(safe_theta_HDC, safe_dot_HDC, 'b')
% hold on
% scatter(unsafe_theta_HDC, unsafe_dot_HDC, 'r')
% hold off
% xlabel('theta')
% ylabel('theta_dot')
% title('HDC Simulation results in the structured dataset')
% legend('safe dataset HDC', 'unsafe datasetd HDC')
% ground_truth_safety_HDC = [safe_theta_HDC; safe_dot_HDC]; 
% ground_truth_unsafety_HDC = [unsafe_theta_HDC; unsafe_dot_HDC];
% save('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/ground_truth_better_safety_HDC.mat', 'ground_truth_safety_HDC');
% 
% writematrix(safe_theta_HDC, '1safe_theta_HDC.txt');
% writematrix(safe_dot_HDC, '1safe_dot_HDC.txt');  
% writematrix(unsafe_theta_HDC, '1unsafe_theta_HDC.txt');  
% writematrix(unsafe_dot_HDC, '1unsafe_dot_HDC.txt');
% 
% 
% % 
%  %% scatter plot // gather training data for LDC
% numP_area = 10000;
% intervalStart = 0; 
% intervalEnd = 2*pi; 
% random_theta = intervalStart + (intervalEnd - intervalStart) * rand(numP_area, 1);
% number_theta = numel(random_theta);
% dotstart = -4;
% dotend = -2;
% random_dot = dotstart + (dotend - dotstart) * rand(numP_area, 1);
% number_dot = numel(random_dot);
% global ini_thetadot_high
% global ini_theta_high
% global input3
% 
% HDC_torque = [];
% HDC_theta = [];
% HDC_dot = [];
% 
% env = rlPredefinedEnv("SimplePendulumWithImage-Continuous");
% 
% %plot(env)
% for i = 1: number_theta
%     %for k = 1:number_dot
%         ini_theta_high = random_theta(i);
%         ini_thetadot_high = random_dot(i);
% 
%         control_steps = 1;
%  
%         observation_test = reset(env);
%         plot(env)
%         % Convert observation to dlarray
%         new_input_images = observation_test{1,1};
%         new_input_scalars = observation_test{1,2};
%         dsX1New = arrayDatastore(new_input_images, 'IterationDimension', 4);
%         dsX2New = arrayDatastore(new_input_scalars');
%         dsNewData = combine(dsX1New, dsX2New);
% 
%         action = predict(loaded_HDC, dsNewData); 
%         %action_items = [action_items,action];
%         HDC_torque = [HDC_torque, action];
% 
%         %for the theta and theta_dot are just our inital states
%         HDC_dot = [HDC_dot, random_dot(i)];
%         HDC_theta = [HDC_theta,random_theta(i)];
% 
%         disp(['finished ', num2str(i)]);
% 
% 
%     %end
% end
% 
% training_data_HDC = [HDC_theta; HDC_dot; HDC_torque];
% save('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/Multi_LDCs/training10000_LDC3_theta0-6.28_dot-4-2.mat', 'training_data_HDC');
% 
% figure
% scatter3(HDC_theta, HDC_dot, HDC_torque); 
% title('3D Scatter Plot with Marker Colors');
% xlabel('theta-Axis');
% ylabel('dot-Axis');
% zlabel('torque-Axis');
% 
% % 
% % 
% % 
% %% LDC training 
% training_LDC_new = load('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/Multi_LDCs/training10000_LDC3_theta0-6.28_dot-4-2.mat');
% training_LDC_new = training_LDC_new.training_data_HDC;
% inputs = [training_LDC_new(1, :); training_LDC_new(2, :)]; % check the first row is the theta and second row is dot
% output = training_LDC_new(3,:);
% 
% % figure
% % scatter3(inputs(1,:), inputs(2, :), output(1, :));
% % xlabel('theta'); ylabel('dot'); zlabel('torque');
% % hold on;
% % scatter3(inputs(1,:), inputs(2, :), output(1, :));
% % xlabel('theta'); ylabel('dot'); zlabel('torque');
% 
% NN_Size = [25,25];  % 2 layers, neuron 10-5
% net = feedforwardnet(NN_Size, 'trainlm');
% net.layers{1}.transferFcn = 'poslin';
% net.layers{2}.transferFcn = 'poslin';
% net.layers{3}.transferFcn = 'purelin';
% 
%  
% net.inputs{1}.processFcns = {}; %delete preprocessing procedure.
% net.outputs{3}.processFcns = {};
% 
% [net,tr] = train(net,inputs, output);
% 
% directory = '/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/Multi_LDCs';
% modelname = 'LDC3_theta0-6.28_dot-2-4.mat';
% fullmodel = fullfile(directory, modelname);
% save(fullmodel, 'net');
% 
%  %% save the LDC into the txt
% net = load('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/Multi_LDCs/LDC3_theta0-6.28_dot-2-4.mat');% 20x20 sigmoid, sigmoid, tanh
% net = net.net;
% weights1 = net.IW{1};
% weights2 = net.LW{2,1};
% weights3 = net.LW{3,2};
% biases = net.b;
% biases1 = biases{1};
% biases2 = biases{2};
% biases3 = biases{3};
% k = 1;
% % weights_bias_LD = zeros(501,1);
% weights_bias_LD = zeros(751,1); %501 neurons dor 20x20 and 751 neurons for 25x25
% num_input = 2;
% num_ouput = 1;
% neurons_1st = 25;
% neurons_2nd = 25;
% %Input the first layer
% for i = 1:neurons_1st %10 is the neuron in the first layer
%     for j = 1:num_input %2 is the size of input
%         weights_bias_LD(k,1) = weights1(i, j);
%         k = k+1;
%     end
%     weights_bias_LD(k) = biases1(i);
%     k = k+1;
% end
% 
% %Input the second layer
% for i = 1:neurons_2nd %5 is the neuron in the second layer. 20 is the neuron in the second layer
%     for j = 1:neurons_1st %2 is the size of neurons in previous layer. 20 is the neuron in the previou layer
%         weights_bias_LD(k,1) = weights2(i, j);
%         k = k+1;
%     end
%     weights_bias_LD(k) = biases2(i);
%     k = k+1;
% end
% 
% %input the third layer
% for i = 1:num_ouput % the neuron in the third layer 
%     for j = 1:neurons_2nd  %the size of neuron in the previous layer
%         weights_bias_LD(k,1) = weights3(i, j);
%         k = k+1;
%     end
%     weights_bias_LD(k) = biases3(i);
%     k = k+1;
% end
% 
% dlmwrite('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/Multi_LDCs/LDC3_theta0-6.28_dot-2-4.txt', weights_bias_LD);
% 
% 
% %% check the validity of txt file
% num_input = 2;
% num_ouput = 1;
% neurons_1st = 25;
% neurons_2nd = 25;
% 
% weights1_other = zeros(neurons_1st, num_input);
% weights2_other = zeros(neurons_2nd, neurons_1st);
% weights3_other = zeros(num_ouput,neurons_2nd);
% 
% bias1_other = zeros(neurons_1st, 1);
% bias2_other = zeros(neurons_2nd, 1);
% bias3_other = zeros(num_ouput,1);
% 
% 
% other_model = load('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/Multi_LDCs/LDC2_theta0-6.28_dot0--2.mat');
% 
% %Input the first layer
% z = 1;
% 
% for i = 1:neurons_1st %10 is the neuron in the first layer
%     for j = 1:num_input %2 is the size of input
%         weights1_other(i, j) = other_model(z);
%         z = z+1;
%     end
%     bias1_other(i) = other_model(z);
%     z = z+1;
% end
% 
% %Input the second layer
% for i = 1:neurons_2nd %5 is the neuron in the second layer. 20 is the neuron in the second layer
%     for j = 1:neurons_1st %2 is the size of neurons in previous layer. 20 is the neuron in the previou layer
%         weights2_other(i, j) = other_model(z);
%         z = z+1;
%     end
%     bias2_other(i) = other_model(z);
%     z = z + 1;
% end
% 
% %input the third layer
% for i = 1:num_ouput % the neuron in the third layer 
%     for j = 1:neurons_2nd  %the size of neuron in the previous layer
%         weights3_other(i, j) = other_model(z);
%         z = z+1;
%     end
%     bias3_other(i) = other_model(z);
%     z=z+1;
% end
% 
% % Simulation with txt file
% control_steps = 30;
% states_test_other = zeros(2,control_steps+1);
% states_test_other(1,1) = 1.1;
% states_test_other(2,1) = 0.8;
% 
% ts = 0.05;
% est_torque_overall_other = zeros(control_steps,1);
% 
% for i = 1:control_steps
%     x = [(states_test_other(1,i)); states_test_other(2,i)];
%     states_1st = weights1_other * x + bias1_other;
%     %states_1st2 = 1 ./ (1 + exp(-states_1st)); %sigmoid
%     %states_1st2 = tanh(states_1st);
%     states_1st2 = max(0,states_1st);
%     states_2nd = weights2_other * states_1st2 + bias2_other;
%     %states_2nd2 = 1 ./ (1 + exp(-states_2nd)); %Sigmoid
%     %states_2nd2 = tanh(states_2nd);
%     states_2nd2 = max(0, states_2nd);
%     states_3rd = weights3_other * states_2nd2 + bias3_other; %linear
%     
%     %states_3rd2 = tanh(states_3rd);
%     est_torque_low = states_3rd;
%     est_torque_overall_other(i) = est_torque_low;
%     dx1 = dynamic1(x, est_torque_low);
%     dx2 = dynamic1(x + ts * dx1, est_torque_low);
%     states_test_other(:,i+1) = x + ts * 0.5 * (dx1+dx2);
%     %states_test_other(1,i+1) =  wrapToPi(states_test_other(1,i+1));
% 
% end
% figure
% subplot(2,2,1)
% plot(states_test_other(1, 1:control_steps), 'LineWidth',2)
% title('LDC test result with the theta by txt')
% 
% subplot(2,2,2)
% plot(states_test_other(2, 1:control_steps), 'LineWidth',2)
% title('LDC test result with the angular velocity by txt')
% 
% subplot(2,2,3)
% plot(est_torque_overall_other(1:control_steps), 'LineWidth',2)
% title('LDC test result with the Torque by txt')
% 




%% Action-based CP

% numP_area = 100;
% inner_point_thetadot =5;
% inner_point_theta = 5;
% theta_seperate = linspace(0,2*pi, inner_point_theta);
% thetadot_seperate = linspace(-8, 0, inner_point_thetadot);

% whole state space
numP_area = 1000;
inner_point_thetadot = 2;
inner_point_theta = 2;
theta_seperate = linspace(0,2*pi, inner_point_theta);
thetadot_seperate = linspace(-8, 0, inner_point_thetadot);

CP_index = ceil(1001*(1-0.05/30));

sampling_theta =zeros(inner_point_theta-1,numP_area);
sampling_thetadot = zeros(inner_point_thetadot-1,numP_area);
for j =1:inner_point_theta-1
    sampling_theta(j,:) = theta_seperate(j) + (theta_seperate(j+1) - theta_seperate(j)) * rand(numP_area, 1);
end

for j =1:inner_point_thetadot-1
    sampling_thetadot(j,:) = thetadot_seperate(j) + (thetadot_seperate(j+1) - thetadot_seperate(j)) * rand(numP_area, 1);
end


% simulation results for two controllers to calculate Y
ctrl_step  = 1;

%load LDC by txt file
other_model = load('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/LDC1_theta0-6.28_dot0-8_wholestate.txt');
num_input = 2;
num_ouput = 1;
neurons_1st = 25;
neurons_2nd = 25;

weights1_other = zeros(neurons_1st, num_input);
weights2_other = zeros(neurons_2nd, neurons_1st);
weights3_other = zeros(num_ouput,neurons_2nd);

bias1_other = zeros(neurons_1st, 1);
bias2_other = zeros(neurons_2nd, 1);
bias3_other = zeros(num_ouput,1);
z = 1;
for i = 1:neurons_1st %10 is the neuron in the first layer
    for j = 1:num_input %2 is the size of input
        weights1_other(i, j) = other_model(z);
        z = z+1;
    end
    bias1_other(i) = other_model(z);
    z = z+1;
end
%Input the second layer
for i = 1:neurons_2nd %5 is the neuron in the second layer. 20 is the neuron in the second layer
    for j = 1:neurons_1st %2 is the size of neurons in previous layer. 20 is the neuron in the previou layer
        weights2_other(i, j) = other_model(z);
        z = z+1;
    end
    bias2_other(i) = other_model(z);
    z = z + 1;
end
%input the third layer
for i = 1:num_ouput % the neuron in the third layer 
    for j = 1:neurons_2nd  %the size of neuron in the previous layer
        weights3_other(i, j) = other_model(z);
        z = z+1;
    end
    bias3_other(i) = other_model(z);
    z=z+1;
end

% load the high-dim controller
env = rlPredefinedEnv("SimplePendulumWithImage-Continuous");
loaded_HDC = load('/Users/yuang/Documents/MATLAB/IP_POLAR_LDC2HDC/HDC_POLAR.mat');
loaded_HDC = loaded_HDC.net;

global ini_thetadot_high
global ini_theta_high

all_torque_two = zeros(3, numP_area);
torque_diff_95 = zeros(inner_point_theta, inner_point_thetadot);

for i = 1:inner_point_theta-1
    sample_theta = sampling_theta(i,:);
    for k = 1:inner_point_thetadot-1
        sample_thetadot = sampling_thetadot(k,:);


for j = 1:numP_area
    int_theta = sample_theta(j);
    int_thetadot = sample_thetadot(j);
    ini_theta_high = int_theta;         %Double check DDPG's theta range from [-pi, pi]
    ini_thetadot_high = int_thetadot;

    % Simulation for high_dimensional controller
    %plot(env)

    observation_test = reset(env);
    plot(env)
    new_input_images = observation_test{1,1};     % Convert observation to dlarray
    new_input_scalars = observation_test{1,2};
    dsX1New = arrayDatastore(new_input_images, 'IterationDimension', 4);
    dsX2New = arrayDatastore(new_input_scalars');
    dsNewData = combine(dsX1New, dsX2New);
    torque_high = predict(loaded_HDC, dsNewData); 

    % Simulation LDC
    ts = 0.05;

    x = [int_theta; int_thetadot];
    states_1st = weights1_other * x + bias1_other;
    %states_1st2 = 1 ./ (1 + exp(-states_1st)); %sigmoid
    %states_1st2 = tanh(states_1st);
    states_1st2 = max(0,states_1st);
    states_2nd = weights2_other * states_1st2 + bias2_other;
    %states_2nd2 = 1 ./ (1 + exp(-states_2nd)); %Sigmoid
    %states_2nd2 = tanh(states_2nd);
    states_2nd2 = max(0, states_2nd);
    states_3rd = weights3_other * states_2nd2 + bias3_other; %linear

    est_torque_low = states_3rd;
    torque_low = est_torque_low;


%     dx1 = dynamic1(x, est_torque_low);
%     dx2 = dynamic1(x + ts * dx1, est_torque_low);
%     states_low(:,L+1) = x + ts * 0.5 * (dx1+dx2);

    all_torque_two(1,j) = torque_high;
    all_torque_two(2,j) = torque_low;
    %all_torque_two(3,j) = abs(torque_high-torque_low);
    all_torque_two(3,j) = torque_high-torque_low;

end
    ascending_order = sort(all_torque_two(3,:));
    torque_diff_95(i,k) = ascending_order(CP_index);
    end
end

% print the cp table
column_dot = cell(1, length(thetadot_seperate)-1);
for i = 1 : numel(thetadot_seperate)-1
str = sprintf('(%0.2f,%0.2f)', thetadot_seperate(i), thetadot_seperate(i+1));
column_dot{i} = str;
end

row_theta = cell(1, length(theta_seperate)-1);
for i = 1 : numel(theta_seperate)-1
str = sprintf('(%d,%d)', theta_seperate(i), theta_seperate(i+1));
row_theta{i} = str;
end

fig = uifigure;
uit = uitable(fig,"Data",torque_diff_95(1:inner_point_theta-1, 1:inner_point_thetadot-1),'ColumnName',column_dot, 'RowName',row_theta);


%% calculate the Lipschitz constant
L1 = norm(weights1_other,2);
L2 = norm(weights2_other,2);
L3 = norm(weights3_other,2);
L_all = L1*L2*L3/16;

%% One simulation of the HDC or LDC





% % Load the LDC
% net = load('/Users/yuang/Documents/NN_20x20_sigmoid_tanh_nopreprocessed_02pi.mat');% 20x20 sigmoid, sigmoid, tanh
% net = net.net; % load the low-dimensioanl controller
% 
% %2nd way to load
% other_model = load('/Users/yuang/Documents/MATLAB/training_LDC/retrain_2nd_L=0.7_range6.txt');
% %other_model = load('/Users/yuang/Documents/MATLAB/training_LDC/2nd_training_low_theta/wb_2nd_20x20sigmoid_tanh.txt');
% num_input = 2;
% num_ouput = 1;
% neurons_1st = 20;
% neurons_2nd = 20;
% 
% weights1_other = zeros(neurons_1st, num_input);
% weights2_other = zeros(neurons_2nd, neurons_1st);
% weights3_other = zeros(num_ouput,neurons_2nd);
% 
% bias1_other = zeros(neurons_1st, 1);
% bias2_other = zeros(neurons_2nd, 1);
% bias3_other = zeros(num_ouput,1);
% z = 1;
% for i = 1:neurons_1st %10 is the neuron in the first layer
%     for j = 1:num_input %2 is the size of input
%         weights1_other(i, j) = other_model(z);
%         z = z+1;
%     end
%     bias1_other(i) = other_model(z);
%     z = z+1;
% end
% %Input the second layer
% for i = 1:neurons_2nd %5 is the neuron in the second layer. 20 is the neuron in the second layer
%     for j = 1:neurons_1st %2 is the size of neurons in previous layer. 20 is the neuron in the previou layer
%         weights2_other(i, j) = other_model(z);
%         z = z+1;
%     end
%     bias2_other(i) = other_model(z);
%     z = z + 1;
% end
% %input the third layer
% for i = 1:num_ouput % the neuron in the third layer 
%     for j = 1:neurons_2nd  %the size of neuron in the previous layer
%         weights3_other(i, j) = other_model(z);
%         z = z+1;
%     end
%     bias3_other(i) = other_model(z);
%     z=z+1;
% end
% 
% 
% safe_theta_LDC = [];
% safe_dot_LDC = [];
% unsafe_theta_LDC = [];
% unsafe_dot_LDC = [];
% 
% TP = 0;
% FP = 0;
% 
% 
% %simluate in the HDC
% for i = 1 : num_theta
%     for k = 1 : num_dot
%     init_theta = theta_interv(i);
%     init_dot = dot_interv(k);
% 
%     ini_theta_high = init_theta;
%     
%     ini_thetadot_high = init_dot;
% 
%     % Simulation for high_dimensional controller
%     env = rlPredefinedEnv("SimplePendulumWithImage-Continuous");
%     obsInfo = getObservationInfo(env);
%     actInfo = getActionInfo(env);
%     %plot(env)
%     simOptions = rlSimulationOptions(MaxSteps = ctrl_step);
%     experience = sim(env,agent,simOptions);
%     
%     theta_high_last = input3(end);
%     % change the negative to positive
%     if theta_high_last < 0
%         theta_high_last = 2*pi + theta_high_last;
%     end
%     %check the safety
%     if theta_high_last <= 6.3 && theta_high_last >= 5.9 || theta_high_last <= 0.2 && theta_high_last >= 0
%         safe_theta_HDC = [safe_theta_HDC, theta_interv(i)];
%         safe_dot_HDC = [safe_dot_HDC, dot_interv(k)];
%     
%     else
%         unsafe_theta_HDC = [unsafe_theta_HDC, theta_interv(i)];
%         unsafe_dot_HDC = [unsafe_dot_HDC, dot_interv(k)];
%     end
% 
% 
%     %Simulation in the LDC
%     states_low = zeros(2,ctrl_step+1);
%     states_low(1,1) = init_theta;
%     states_low(2,1) = init_dot;
%     ts = 0.05;
%     est_torque_overall = zeros(ctrl_step,1);
%     
%     for m = 1:ctrl_step
%         x = [(states_low(1,m)); states_low(2,m)];
%         est_torque_low = sim(net, x)*2; % Remember x2
%         est_torque_overall(m) = est_torque_low;
%         dx1 = dynamic1(x, est_torque_low);
%         dx2 = dynamic1(x + ts * dx1, est_torque_low);
%         states_low(:,m+1) = x + ts*0.5*(dx1+dx2);
%     end
%     if states_low(1,end) < 0
%         states_low(1,end) = 2*pi + states_low(1,end);
%     end
%     if states_low(1, end) <= 6.3 && states_low(1, end) >= 5.9 || states_low(1, end) <= 0.2 && states_low(1, end) >= 0
%         safe_theta_LDC = [safe_theta_LDC, init_theta];
%         safe_dot_LDC = [safe_dot_LDC, init_dot];
%     
%     else
%         unsafe_theta_LDC = [unsafe_theta_LDC, init_theta];
%         unsafe_dot_LDC = [unsafe_dot_LDC, init_dot];
%     end
%     fprintf('Finished: (%d, %d)\n', i, k);
%     %Record the confusion matrix
%     if ~isempty(safe_theta_LDC) && ~isempty(safe_theta_HDC)
%         if safe_theta_LDC(end) == safe_theta_HDC(end) && safe_dot_LDC(end) == safe_dot_HDC(end)
%             TP = TP + 1;
%         end
%     end
%     if ~isempty(unsafe_theta_LDC) && ~isempty(unsafe_theta_HDC)
%         if unsafe_theta_LDC(end) == unsafe_theta_HDC(end) && unsafe_dot_LDC(end) == unsafe_dot_HDC(end)
%             FP = FP + 1;
%         end
%     end
% 
%     end
% end
% 
% 
% % Sample data
% A = [1 2 3 4 5 7 2; 
%      6 7 8 9 10 9 1];
% 
% B = [3 4 5 6 7 2; 
%      8 9 10 11 12 1];
% 
% % Find matching columns
% [matching, indexA] = ismember(A', B', 'rows');
% 
% % Display the matching columns from A (or B, since they are the same)
% matchingColumns = A(:, matching);
% 
% 
% disp(matchingColumns);
% 
% % calculate the confusion matrix
% 
% safe_HDC = [safe_theta_HDC; safe_dot_HDC];
% safe_LDC = [safe_theta_LDC; safe_dot_LDC];
% 
% [matching, index_LDC] = ismember(safe_HDC', safe_LDC', 'rows');
% matchingColumns = safe_HDC(:, matching);
% 
% unsafe_HDC = [unsafe_theta_HDC; unsafe_dot_HDC];
% unsafe_LDC = [unsafe_theta_LDC; unsafe_dot_LDC];
% 
% [matching_unsafe, index_LDC_unsafe] = ismember(unsafe_HDC', unsafe_LDC', 'rows');
% matchingColumns_unsafe = unsafe_HDC(:, matching_unsafe);
% 
% %Draw an overall plot
% figure
% scatter(safe_theta_HDC, safe_dot_HDC, 'b')
% hold on
% scatter(unsafe_theta_HDC, unsafe_dot_HDC, 'r')
% hold off
% xlabel('theta')
% ylabel('theta_dot')
% title('HDC Simulation results in the structured dataset')
% legend('safe dataset HDC', 'unsafe datasetd HDC')
% 
% figure
% scatter(safe_theta_LDC, safe_dot_LDC, 'b')
% hold on
% scatter(unsafe_theta_LDC, unsafe_dot_LDC, 'r')
% hold off
% xlabel('theta')
% ylabel('theta_dot')
% legend('safe dataset LDC', 'unsafe datasetd LDC')
% title('LDC Simulation results in the structured dataset')

%check the safety for both controllers last state in safe or not.
%Therefore, we can have two red-blue plots. (0,1)

%calculate the recall or whatever other method.
 
function [dx,tau] = dynamic1(x,tau) %at time t to get dtheta, ddtheta
g = 9.81;
L = 1;
m = 1; 
theta  = x(1);
dtheta = x(2);
dx(1,1) = dtheta;
dx(2,1) = 1/(m*L^2) * (tau + m*g*L*sin(theta));
end

