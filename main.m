%% Constants
POWER = 160e6 / 3.2e-11; % num fissions
CORE_WIDTH = 4.6; % m
LAYOUT = [  0, 0, 1, 1, 1, 0, 0;
            0, 1, 1, 1, 1, 1, 0;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            0, 1, 1, 1, 1, 1, 0;
            0, 0, 1, 1, 1, 0, 0;]; 

% material 0 is a mixture of steel and air
% material 1 is a placeholder for the fuel. The layout should be multiplied by the index of the desired fuel state

%% Material Data Creation

%% Build Matrices
[num_nodes_x, num_nodes_y] = size(LAYOUT);
node_width = CORE_WIDTH / num_nodes_x;
SPAN = num_nodes_x * num_nodes_y;
disp('Building Matrices')



