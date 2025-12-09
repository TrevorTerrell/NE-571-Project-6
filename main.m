clear
clc

%% Constants
POWER = 250e6 / 3.2e-11; % num fissions
CORE_WIDTH = 4.6; % m
% LAYOUT_BASE = [
%     0, 0, 1, 2, 1, 0, 0;
%     0, 3, 4, 5, 4, 3, 0;
%     1, 4, 6, 7, 6, 4, 1;
%     2, 5, 7, 8, 7, 5, 2;
%     1, 4, 6, 7, 6, 4, 1;
%     0, 3, 4, 5, 4, 3, 0;
%     0, 0, 1, 2, 1, 0, 0;
% ]; 
LAYOUT_BASE = [
    0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 2, 1, 0, 0, 0;
    0, 0, 3, 4, 5, 4, 3, 0, 0;
    0, 1, 4, 6, 7, 6, 4, 1, 0;
    0, 2, 5, 7, 8, 7, 5, 2, 0;
    0, 1, 4, 6, 7, 6, 4, 1, 0;
    0, 0, 3, 4, 5, 4, 3, 0, 0;
    0, 0, 0, 1, 2, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0;
]; 

RODDED = [2; 4; 7] + 1;

SCALE_FACTOR = 1;
LAYOUT = ScaleLayout(LAYOUT_BASE + 1, SCALE_FACTOR);

% fuel pellet OD = 0.8155 cm
% active height = 2 m
% 264 fuel rods per assemble

ASS_U_MASS = (pi * (0.8115 / 100)^2 * 2) * 264 * 10.97; %MTU
vec_boron = [];

%% Get Initial Flux
[num_nodes_x, num_nodes_y] = size(LAYOUT);
node_width = CORE_WIDTH / (num_nodes_x + 1) * 100; %cm

[crit, flux, boron, materials] = BisectSolve(LAYOUT, zeros(8,1), RODDED, node_width, node_width, 10e-5);
vec_boron(end + 1) = boron;
figure(1);
x_vals = linspace(0, CORE_WIDTH * sqrt(2), num_nodes_x + 2);

[n_flux, power] = NormalizeFluxAndPower(flux, LAYOUT, materials, POWER, 2, num_nodes_x * num_nodes_y, node_width);

fprintf('k = %.5f\n', crit);
power = ScaleLayout(power, 1/SCALE_FACTOR) * SCALE_FACTOR^2;
burnup = PowerToBurnup(power, ASS_U_MASS);
disp(burnup)
mat_burnup = GetMaterialAvg(LAYOUT_BASE, burnup);

for g = 1:2
    center_line = diag(n_flux(g).f);
    plot(x_vals, center_line, 'DisplayName', sprintf('Group %i', g - 1), 'LineWidth', 3);
    hold("on");
end

xlabel("Position (m)")
ylabel("Flux (neutrons/cm^2)")
legend("show");

%% Time step 2
figure(2);
while (max(mat_burnup) < 24) && (boron > 0)
    [crit, flux, boron, materials] = BisectSolve(LAYOUT, mat_burnup, RODDED, node_width, node_width, 10e-5);
    vec_boron(end + 1) = boron;
    [n_flux, power] = NormalizeFluxAndPower(flux, LAYOUT, materials, POWER, 2, num_nodes_x * num_nodes_y, node_width);

    fprintf('k = %.5f, boron = %.2f\n', crit, boron);
    power = ScaleLayout(power, 1/SCALE_FACTOR) * SCALE_FACTOR^2;
    burnup = PowerToBurnup(power, ASS_U_MASS) + burnup;
    disp(burnup)
    mat_burnup = GetMaterialAvg(LAYOUT_BASE, burnup);
    
end

for g = 1:2
    center_line = diag(n_flux(g).f);
    plot(x_vals, center_line, 'DisplayName', sprintf('Group %i', g - 1), 'LineWidth', 3);
    hold("on");
end

xlabel("Position (m)");
ylabel("Flux (neutrons/cm^2)");
legend("show");

figure(3)
x_vals = 1:size(vec_boron, 2);
x_vals = x_vals * 150;
plot(x_vals, vec_boron, 'LineWidth', 3);
hold("on")
xlabel("Time (days)");
ylabel("Boron (ppm)");
title("Boron Needed for a Criticality of 1");