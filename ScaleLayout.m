function scaled_layout = ScaleLayout(layout, factor)
% ScaleLayout   Splits each node into subnodes
%
%   layout  :   2D matrix holding the material ID for each node
%   factor  :   number of 1D subdivisions (a factor of 2 will turn each unit node into a 2x2 area) 

    [NX, NY] = size(layout);
    NX = NX * factor;
    NY = NY * factor;

    scaled_layout = zeros([NX, NY]);

    for i = 1:NX
        for j = 1:NY
            scaled_layout(i,j) = layout(ceil(i/factor), ceil(j/factor));
        end
    end
end