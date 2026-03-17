function x = round_to_larger_decade(x)
% Returns value rounded to the decade larger

p = ceil(log10(x));
x = 10.^p;