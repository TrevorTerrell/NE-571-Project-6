function [flux, power_map] = NormalizeFluxAndPower(u_flux, layout, mats, neutronic_power, groups, nodes_per_group, dx)

    jpf = 3.2e-11; %joules per fission

    flux(groups).f = zeros(sqrt(nodes_per_group));
    fiss_factor(groups).f = zeros(sqrt(nodes_per_group));
    unorm_power = 0;
    power_map = zeros(sqrt(nodes_per_group));

    for g = 1:groups
        st = 1 + (nodes_per_group * (g - 1));
        sp = nodes_per_group * g;
        g_flux = u_flux(st:sp);
        g_spacial_flux = SpatialFlux(g_flux, sqrt(nodes_per_group) + 2, sqrt(nodes_per_group) + 2);

        flux(g).f = g_spacial_flux .* dx .* dx;
        fiss_factor(g).f = GetFissNormFactor(flux(g).f, layout, mats, g);
        unorm_power = unorm_power + sum(sum(fiss_factor(g).f));
    end

    for g = 1:groups
        flux(g).f = flux(g).f .* neutronic_power ./ unorm_power ./ dx ./ dx;
        FF = GetFissNormFactor(flux(g).f, layout, mats, g);
        power_map = power_map + FF(2:end-1, 2:end-1);
    end

    power_map = power_map .* jpf .* dx .* dx;
    

end