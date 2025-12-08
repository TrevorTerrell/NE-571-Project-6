clear
clc

%% Constants
POWER = 160e6 / 3.2e-11; % num fissions
CORE_WIDTH = 4.6; % m
LAYOUT_BASE = [
    0, 0, 1, 2, 1, 0, 0;
    0, 3, 4, 5, 4, 3, 0;
    1, 4, 6, 7, 6, 4, 1;
    2, 5, 7, 8, 7, 5, 2;
    1, 4, 6, 7, 6, 4, 1;
    0, 3, 4, 5, 4, 3, 0;
    0, 0, 1, 2, 1, 0, 0;
]; % 0 = water, 1 = fuel_1, 2 = fuel 2
%initial core drops to 12 GWd/MTU, so fuel 1 = 0 GWd, fuel 2 = 12 GWd...

RODDED = [2; 4; 7] + 1;

SCALE_FACTOR = 9;
LAYOUT = ScaleLayout(LAYOUT_BASE + 1, SCALE_FACTOR);

% fuel pellet OD = 0.8155 cm
% active height = 2 m
% 264 fuel rods per assemble

ASS_U_MASS = (pi * (0.8155 / 100)^2 * 2) * 265 * 10.97; %MTU

% material 0 is a mixture of steel and air
% material 1 is a placeholder for the fuel. The layout should be multiplied by the index of the desired fuel state

%% Material Data Creation
%Burnup spans 0-60, Boron spans 2500-0 ppm
boron = 1168;
materials(9) = GetMaterialStruct(0, boron, 'cross_sections_reflector_2g.csv');
materials(1) = GetMaterialStruct(0, boron, 'cross_sections_reflector_2g.csv');

for i = 1:8
    if ismember(i, RODDED)
        file = 'cross_sections.csv';
    else
        file = 'Rodded_cross_sections.csv';
    end
    materials(i + 1) = GetMaterialStruct(0, boron, file);
end

%% Get Initial Flux
[num_nodes_x, num_nodes_y] = size(LAYOUT);
node_width = CORE_WIDTH / (num_nodes_x + 1) * 100; %cm

[crit, flux] = SolveCore(LAYOUT, materials, node_width, node_width);

%% Plotting Flux
x_vals = linspace(0, CORE_WIDTH * sqrt(2), num_nodes_x + 2);

[n_flux, power] = NormalizeFluxAndPower(flux, LAYOUT, materials, POWER, 2, num_nodes_x * num_nodes_y, node_width);

fprintf('k = %.5f\n', crit);
power = ScaleLayout(power, 1/SCALE_FACTOR) * SCALE_FACTOR^2;
%disp(sum(sum(power)))
burnup = PowerToBurnup(power, ASS_U_MASS);
disp(burnup)
% disp(sum(sum(burnup)))

for g = 1:2
    center_line = diag(n_flux(g).f);
    plot(x_vals, center_line, 'DisplayName', sprintf('Group %i', g - 1), 'LineWidth', 3);
    hold("on");
end

xlabel("Position (m)")
ylabel("Flux (neutrons/cm^2)")
legend("show");


