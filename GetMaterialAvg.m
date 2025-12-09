function out = GetMaterialAvg(layout, in)
% GetMaterialAvg    Averages the porperties in `in` according to their material index.
%
%   layout  :   2D matrix holding the material ID for each node
%   in      :   2D matrix holding the values
    num = max(max(layout));
    out = zeros(num, 1);
    for i = 1:num
        out(i) = mean(in(layout == i));
    end
end