clear
clc

%% Constants
POWER = 160e6 / 3.2e-11; % num fissions
CORE_WIDTH = 4.6; % m
LAYOUT_BASE = [
    2, 2, 1, 1, 1, 2, 2;
    2, 1, 1, 1, 1, 1, 2;
    1, 1, 1, 1, 1, 1, 1;
    1, 1, 1, 1, 1, 1, 1;
    1, 1, 1, 1, 1, 1, 1;
    2, 1, 1, 1, 1, 1, 2;
    2, 2, 1, 1, 1, 2, 2;
];

LAYOUT = ScaleLayout(LAYOUT_BASE, 1);

% fuel pellet OD = 0.8155 cm
% active height = 2 m
% 264 fuel rods per assemble

ASS_U_MASS = (pi * (0.8155 / 100)^2 * 2) * 265 * 10.97; %MTU

% material 0 is a mixture of steel and air
% material 1 is a placeholder for the fuel. The layout should be multiplied by the index of the desired fuel state

%% Material Data Creation
materials(1).fiss = [ 0.003320; 0.07537 ];
materials(1).nu   = [ 0.008476; 0.18514 ] ./ materials(1).fiss;
materials(1).abs  = [ 0.012070; 0.12100 ];
materials(1).diff = [ 1.262700; 0.35430 ];
materials(1).sct  = [ 0.01412 ];
materials(1).rm   = [ 0.026190; 0.12100 ];

materials(2).fiss = [ 0;      0      ];
materials(2).nu   = [ 0;      0      ];
materials(2).abs  = [ 0.0004; 0.0197 ];
materials(2).diff = [ 1.13;   0.16   ];
materials(2).sct  = [ 0.0494 ];
materials(2).rm   = [ 0.0498; 0.0197 ];
%% Get Initial Flux
[num_nodes_x, num_nodes_y] = size(LAYOUT);
node_width = CORE_WIDTH / (num_nodes_x + 1) * 100; %cm

[crit, flux] = SolveCore(LAYOUT, materials, node_width, node_width);

%% Plotting Flux

% groups = 2;

x_vals = linspace(0, CORE_WIDTH * sqrt(2), num_nodes_x + 2);
% nodes_per_group = num_nodes_x * num_nodes_y;

% groupData(groups).flux = zeros(num_nodes_x, num_nodes_y);
% groupData(groups).fiss_factor = 0;
% unorm_power = 0;

% figure(1);

% for g = 1:groups
%     st = 1 + (nodes_per_group * (g - 1));
%     sp = nodes_per_group * g;
%     g_flux = flux(st:sp);
%     g_spacial_flux = SpatialFlux(g_flux, num_nodes_x + 2, num_nodes_y + 2);

%     groupData(g).flux = g_spacial_flux .* node_width .* node_width;
%     groupData(g).fiss_factor = GetFissNormFactor(groupData(g).flux, LAYOUT, materials, g);
%     unorm_power = unorm_power + groupData(g).fiss_factor;
% end

% for g = 1:groups
%     groupData(g).flux = groupData(g).flux .* POWER ./ unorm_power ./ node_width ./ node_width;
%     center_line = diag(groupData(g).flux);
%     plot(x_vals, center_line, 'DisplayName', sprintf('Group %i', g - 1), 'LineWidth', 3);
%     hold("on");
% end

[n_flux, power] = NormalizeFluxAndPower(flux, LAYOUT, materials, POWER, 2, num_nodes_x * num_nodes_y, node_width);

disp(power)
disp(sum(sum(power)))
burnup = PowerToBurnup(power, ASS_U_MASS);
disp(burnup)
disp(sum(sum(burnup)))

for g = 1:2
    center_line = diag(n_flux(g).f);
    plot(x_vals, center_line, 'DisplayName', sprintf('Group %i', g - 1), 'LineWidth', 3);
    hold("on");
end

xlabel("Position (m)")
ylabel("Flux (neutrons/cm^2)")
legend("show");


