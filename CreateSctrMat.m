function S = CreateSctrMat(layout, materials, g)
% CreateLossMat Creates the F matrix for the A * phi = F * phi / k equation.
%
%   layout: 2D matrix holding the material ID for each node
%   materials: struct with the following components:
%       sct: downscattering cross section
%   g: number of energy groups

    % % Shrink layout b/c 0 boundary condition
    layout = reshape(layout, 1, []);
    N = size(layout, 2);

    Sc = arrayfun(@(id) materials(id).sct(g), layout);

    S = spdiags(Sc', 0, N, N);
end
