function [crit, flux, boron, materials] = BisectSolve(layout, burnup, rodded, dx, dy, tol)
    boron_max = 2500; %max we have data for
    boron_min = 0;
    boron_mid = 2500/2;
    n = 0;
    while n < 20
        n = n + 1;
        materials(9) = GetMaterialStruct(0, boron_mid, 'cross_sections_reflector_2g.csv');
        materials(1) = GetMaterialStruct(0, boron_mid, 'cross_sections_reflector_2g.csv');

        for i = 1:8
            if ismember(i, rodded)
                materials(i + 1) = GetMaterialStruct(burnup(i), boron_mid, 'Rodded_cross_sections.csv');
            else
                materials(i + 1) = GetMaterialStruct(burnup(i), boron_mid, 'cross_sections.csv');
            end
        end

        [crit, flux] = SolveCore(layout, materials, dx, dy);

        if crit - 1 > tol 
            boron_min = boron_mid;
        elseif crit - 1 < -tol
            boron_max = boron_mid;
        else
            boron = boron_mid;
            return
        end
        boron_mid = (boron_max + boron_min)/2;

    end

    boron = 0;

end