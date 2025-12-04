function scaled_layout = ScaleLayout(layout, factor)
% ScaleLayout   Splits each node into subnodes or averages subnodes into nodes
%
%   layout  :   2D matrix holding the material ID for each node
%   factor  :   number of 1D subdivisions (a factor of 2 will turn each unit node into a 2x2 area) 

    [NX_og, NY_og] = size(layout);
    NX = NX_og * factor;
    NY = NY_og * factor;

    scaled_layout = zeros([NX, NY]);
    if factor > 1
        for i = 1:NX
            for j = 1:NY
                scaled_layout(i,j) = layout(ceil(i/factor), ceil(j/factor));
            end
        end
    else
        for i = 1:NX
            for j = 1:NY
                scaled_layout(i,j) = mean(mean(layout(((i-1)/factor + 1):i/factor, ((j-1)/factor + 1):j/factor)));
            end
        end
    end
end