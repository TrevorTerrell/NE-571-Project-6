function mat = GetMaterialStruct(burnup, boron, filename)
% GetMaterialStruct Translates a burnup and a boron concentration to a struct of cross section data
%
%   burnup  :   the amount of burnup in GWd/MUT
%   boron   :   the concentration of boron in ppm
%   filename:   the filename and path of the cross section data

    data = readtable(filename);
    if contains(filename, 'reflector')
        mat.fiss    = [0.0; 0.0];
        mat.nu      = [0.0; 0.0];
        mat.abs     =  arrayfun(@(g) GetCrossSec(boron, burnup, g, 'absorption',  data, true), 1:2);
        mat.diff    =  arrayfun(@(g) GetCrossSec(boron, burnup, g, 'diffusion',   data, true), 1:2);
        mat.sct     = [arrayfun(@(g) GetCrossSec(boron, burnup, g, 'out_scatter', data, true), 1); 0.0];

    else
        mat.fiss    =  arrayfun(@(g) GetCrossSec(boron, burnup, g, 'fission',     data), 1:2);
        mat.nu      =  arrayfun(@(g) GetCrossSec(boron, burnup, g, 'nu_fission',  data), 1:2) ./ mat.fiss;
        mat.abs     =  arrayfun(@(g) GetCrossSec(boron, burnup, g, 'absorption',  data), 1:2);
        mat.diff    =  arrayfun(@(g) GetCrossSec(boron, burnup, g, 'diffusion',   data), 1:2);
        mat.sct     = [arrayfun(@(g) GetCrossSec(boron, burnup, g, 'out_scatter', data), 1); 0.0];
    end

    
    mat.rm = mat.abs + mat.sct;
end