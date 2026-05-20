function [ticks, tick_labels] = return_neat_ticks(d, options)
    % Function returns neat ticks

    arguments
        d (:,:) double = [];

        options.no_of_ticks = 2;
        
        options.min_decade_factor = 0.2
        options.min_d_min_threshold = 0.001
        
        options.max_decade_factor = 0.2
        options.min_d_max_threshold = 0.001

        options.max_decimal_places = 3
        options.g_decimal_places = 3

        options.include_zero = true
    end

    % Code

    % Straighten out input data
    d = d(:);

    % Find the magnitude of the largest decade
    largest_decade = round_to_largest_decade(max(abs(d)));

    d_min = multiple_less_than(min(d), ...
                options.min_decade_factor * abs(largest_decade));
    % Handle small values
    if ( (d_min > 0) && (d_min < options.min_d_min_threshold) )
        d_min = 0;
    end

    d_max = multiple_greater_than(max(d), ...
        options.max_decade_factor * abs(largest_decade));
    if ( (d_max < 0) && (abs(d_max) < options.min_d_max_threshold) )
        d_max = 0;
    end

    if (options.include_zero)
        d_min = min([0 d_min]);
        d_max = max([0 d_max]);

        if ((d_min < 0) && (d_max > 0))
            ticks = [d_min 0 d_max];
        else
            ticks = [d_min d_max];
        end
    else
        ticks = linspace(d_min, d_max, options.no_of_ticks);
    end

    if (d_min ~= 0)
        decimal_places = max([0 ...
            -log10(round_to_largest_decade(abs(d_min)))+1]);
    else
        decimal_places = max([0 ...
            -log10(round_to_largest_decade(abs(d_max)))+1]);
    end

    if (decimal_places <= options.max_decimal_places)
        format_string = sprintf('%%.%if', decimal_places);
    else
        % Switch to %g
        format_string = sprintf('%%.%ig', options.g_decimal_places);
    end

    for i = 1 : numel(ticks)
        tick_labels(i) = string(sprintf(format_string, ticks(i)));
    end



