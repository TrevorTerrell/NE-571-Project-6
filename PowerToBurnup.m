function burnup = PowerToBurnup(power_map, tonsU)
% PowerToBurnup Converts a power map in J to a burnup map in GWd/MTU
    burnup = power_map .* 1e-9 .* (1 / 24 * 3600) / tonsU;
end