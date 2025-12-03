function factor = GetFissNormFactor(flux, layout, materials, group)

    [NX, NY] = size(layout);
    NX = NX + 2; NY = NY + 2;
    fiss = zeros(NY,NY);
    fiss(2:NY-1, 2:NX-1) = arrayfun(@(id) materials(id).fiss(group), layout);

    factor = sum(sum(fiss .* flux));
end