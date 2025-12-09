function A = CreateLossMat(layout, materials, dx, dy, g)
% CreateLossMat Creates the A matrix for the A * phi = F * phi / k equation.
%
%   layout: 2D matrix holding the material ID for each node
%   materials: struct with the following components:
%       diff: diffusion coefficient
%       rm: removal cross section
%   dx: width of 1 node in the x direction
%   dy: width of 1 node in the y direction
%   g: number of energy groups
    [Nx, Ny] = size(layout);

    diff_map    = arrayfun(@(id) materials(id).diff(g), layout);
    rm_map      = arrayfun(@(id) materials(id).rm(g),   layout);

    A_only_c = 2 * diff_map * (dx^2 + dy^2) / (dx^2 * dy^2) + rm_map;
    A_only_e = - diff_map / dx^2;
    A_only_w = A_only_e;
    A_only_w(1, :) = 0;
    A_only_e(end, :) = 0;
    A_only_s = - diff_map / dy^2;
    A_only_n = A_only_s;
    A_only_n(:, 1) = 0;
    A_only_s(:, end) = 0;

    A_only_c = A_only_c(:);
    A_only_e = A_only_e(:);
    A_only_w = A_only_w(:);
    A_only_n = A_only_n(:);
    A_only_s = A_only_s(:);

    A = diag(A_only_c) + diag(A_only_e(1:end-1), 1) + diag(A_only_w(2:end), -1) + diag(A_only_n(1+Nx:end), Nx) + diag(A_only_s(1:end-Nx), - Nx);

end
