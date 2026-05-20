function x = round_to_largest_decade(x)
% Returns value rounded to the decade larger

if (x > 0)
    p = ceil(log10(x));
    x = 10.^p;
else
    p = ceil(log10(-x));
    x = -10.^p;
end
