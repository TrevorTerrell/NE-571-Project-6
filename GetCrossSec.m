function xs = GetCrossSec(boron_ppm, burnup, group, reaction, xsTable, isReflector)
% GetCrossSec  Returns interpolated cross sections from parsed CSV table.
%
% boron_ppm  = boron concentration (ppm)
% burnup     = burnup (MWd/kgU)      (ignored for reflector case)
% group      = energy group number   (1, 2, 3, ...)
% reaction   = "absorption", "capture", ...
% xsTable    = preloaded XS table (from readtable)
%
% xs         = interpolated cross section value

arguments
    boron_ppm   (1,1) double
    burnup      (1,1) double
    group       (1,1) double
    reaction    (1,1) string
    xsTable     table
    isReflector = false
end


% Now filter by group
xsTable = xsTable(xsTable.group == group, :);

if isempty(xsTable)
    error("No matching rows in table for case=%s group=%d", caseType, group);
end

% --- BASE / RODDED FULL 2D INTERPOLATION --------------------------

% Extract grids
vec_boron   = xsTable.boron;
vec_burnup  = xsTable.burnup;
vec_vals    = xsTable.(reaction);

% Evaluate
if ~isReflector
    mat_F = scatteredInterpolant(vec_boron, vec_burnup, vec_vals, 'linear', 'none');
    xs = mat_F(boron_ppm, burnup);
else
    xs = interp1(vec_boron, vec_vals, boron_ppm);
end
