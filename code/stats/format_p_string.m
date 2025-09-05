function s = format_p_string(p, options)
    % Returns a nicely formatted p string

    arguments
        p (1,1) double
        options.threshold (1,1) double = 0.001;
    end

    if (p < options.threshold)
        s = sprintf('p < %.3f', options.threshold);
    else
        s = sprintf('p = %.3f', p);
    end
end
