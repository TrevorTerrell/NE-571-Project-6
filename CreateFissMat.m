function F = CreateFissMat(layout, materials, g)
% CreateLossMat Creates the F matrix for the A * phi = F * phi / k equation.
%
%   layout: 2D matrix holding the material ID for each node
%   materials: struct with the following components:
%       fiss: fission cross section
%       nu: number of neutrons per fission
%   g: number of energy groups
    layout = reshape(layout, 1, []);
    N = size(layout, 2);

    nf = arrayfun(@(id) materials(id).fiss(g) .* materials(id).nu(g), layout);
    F = spdiags(nf', 0, N, N);
    
end
