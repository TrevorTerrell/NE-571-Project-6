function factor = GetFissNormFactor(flux, layout, materials, group)
% GetFissNormFactor Generates a matrix holding the value of the neutron flux times the fission cross section
%   
%   flux        :   a map of the neutron flux
%   layout      :   2D matrix holding the material ID for each node
%   materials   :   struct with the following components:
%       fiss:   fission cross section
%   group       :   number of energy groups

    [NX, NY] = size(layout);
    NX = NX + 2; NY = NY + 2;
    fiss = zeros(NY,NY);
    fiss(2:NY-1, 2:NX-1) = arrayfun(@(id) materials(id).fiss(group), layout);

    factor = fiss .* flux;
end