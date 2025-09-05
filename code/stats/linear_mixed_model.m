function stats = linear_mixed_model(t, data_label, f1_label, options);

    arguments
        t (:,:) table
        data_label (1,1) string
        f1_label (1,1) string
        options.f2_label (1,1) string = ""
        options.grouping_label (1,1) string = ""
        options.figure_handle (1,1) double = 0
        options.subplot_handle (1,1) double = 0

    end

    % Code

    % Start by defining the mode as "one_way", could be updated later
    model_mode = "one_way";

    % Try to fix variable names by removing sapces
    f1_label = strrep(f1_label, ' ', '');
    if (options.f2_label ~= "")
        options.f2_label = strrep(options.f2_label, ' ', '');
    end

    % Set the model_string
    model_string = data_label + " ~ 1 + " + f1_label;
    
    if (options.f2_label ~= "")
        model_mode = "two_way";
        model_string = model_string + " + " + options.f2_label + ...
            " + (" + f1_label +  " * " + options.f2_label + ")";
    end 

    if (options.grouping_label ~= "")
        model_string = model_string + " + (1 | " + options.grouping_label + ")";
    end

    % Get estimates of groups
    lin_mix_mod_ref = fitlme(t, model_string, ...
        FitMethod = "REML", ...
        CovariancePattern = "CompSym", ...
        DummyVarCoding = "Reference");

    % Run the model
    lin_mix_mod_effects = fitlme(t, model_string, ...
        FitMethod = "REML", ...
        CovariancePattern = "CompSym", ...
        DummyVarCoding = "Effects");

    % Set the main effects
    main_effects = anova(lin_mix_mod_effects, ...
        DFMethod = "satterthwaite");

    % Switch depending on mode
    switch model_mode

        case "one_way"
           
            % Work out the variable names for the post-hoc tests
            d_m = designMatrix(lin_mix_mod_ref);
            d_un = unique(d_m, 'rows');
            for i = 1 : size(d_un, 1)
                [~, ia, ib] = intersect(d_m, d_un(i,:), 'rows');
                d_vn(i) = t.(f1_label)(ia);
            end

            % Now get the combinations we need to test
            nck = nchoosek(1:size(d_un, 1), 2);

            % Run them
            for i = 1 : size(nck, 1)
                post_hoc.varname_1(i) = d_vn(nck(i,1));
                post_hoc.varname_2(i) = d_vn(nck(i,2));
                h = d_un(nck(i,1), :) - d_un(nck(i,2), :);

                [post_hoc.p_raw(i), post_hoc.F(i), ...
                    post_hoc.df1(i), post_hoc.df2(i)] = ...
                    coefTest(lin_mix_mod_ref, h, [0], ...
                        DFMethod = 'Satterthwaite');
            end

        case "two_way"
            % Work out the factor_1 and factor_2 names
            f1_values = unique(t.(f1_label));
            f2_values = unique(t.(options.f2_label));

             % Work out the variable names for the post-hoc tests
            d_m = designMatrix(lin_mix_mod_ref);
            d_un = unique(d_m, 'rows');
            for i = 1 : size(d_un, 1)
                [~, ia, ib] = intersect(d_m, d_un(i,:), 'rows');
                d_vn1(i) = t.(f1_label)(ia);
                d_vn2(i) = t.(options.f2_label)(ia);
            end

            % Find the design matrices for each combination;
            un_f1 = unique(d_vn1);
            un_f2 = unique(d_vn2);

            combos = [];
            counter = 1;
            for i = 1 : numel(un_f1)
                for j = 1 : numel(un_f2)
                    vi = find( (strcmp(d_vn1, un_f1{i})) & ...
                            (strcmp(d_vn2, un_f2{j})));
                    combos.var_names(counter) = string(sprintf('%s:%s', ...
                        d_vn1{vi}, d_vn2{vi}));
                    combos.matrix_entries(counter,:) = d_un(vi,:);
                    counter = counter + 1;
                end
            end

            % Build up the combinations
            comps = [];
            for i = 1 : numel(un_f1)
                % Find the combos that start with the chosen f1
                vi_f1 = find(startsWith(combos.var_names, un_f1(i)));
                if (numel(vi_f1) > 1)
                    comps = [comps ; nchoosek(vi_f1, 2)];
                end
            end
            for i = 1 : numel(un_f2)
                % Find the combos that end with the chose chosen f2
                vi_f2 = find(endsWith(combos.var_names, un_f2(i)));
                comps = [comps ; nchoosek(vi_f2, 2)];
            end


            % Now run the tests
            for i = 1 : size(comps, 1)
                post_hoc.varname_1(i) = combos.var_names(comps(i,1));
                post_hoc.varname_2(i) = combos.var_names(comps(i,2));

                h = combos.matrix_entries(comps(i,1), :) - ...
                        combos.matrix_entries(comps(i,2), :);

                [post_hoc.p_raw(i), post_hoc.F(i), ...
                    post_hoc.df1(i), post_hoc.df2(i)] = ...
                        coefTest(lin_mix_mod_ref, h, [0], ...
                            DFMethod = 'Satterthwaite');
            end
    end

    % Form the post_hoc table
    post_hoc = struct2table(columnize_structure(post_hoc));

    % Perform Holm-Bonferroni correction
    % Sort table
    post_hoc = sortrows(post_hoc, 'p_raw');

    mult = size(post_hoc, 1)
    for i = 1 : size(post_hoc, 1)
        post_hoc.p_corrected(i) = mult * post_hoc.p_raw(i);
        mult = mult - 1;
    end

    % Sort by new order
    post_hoc = sortrows(post_hoc, 'p_corrected');

    % Format the main effects strings
    % We always have the first term
    main_effects_string = string( ...
        sprintf('%s: %s', main_effects.Term{2}, ...
           format_p_string(main_effects.pValue(2))));
    % Add in the second and interaction if required
    if (model_mode == 'two_way')
        main_effects_string = string( ...
            sprintf('%s\n%s: %s\n%s * %s: %s', ...
                main_effects_string, main_effects.Term{3}, ...
                    format_p_string(main_effects.pValue(3)), ...
                    main_effects.Term{2}, main_effects.Term{3}, ...
                    format_p_string(main_effects.pValue(4))));
    end

    % Assemble output
    stats.main_effects = main_effects;
    stats.main_effects(1,:) = [];

    stats.post_hoc = post_hoc;
    stats.model_string = model_string;
    stats.main_effects_string = main_effects_string;


    % Make the figure if necessary
    if ((options.subplot_handle ~= 0) || ...
            (options.figure_handle ~= 0))

        if (options.subplot_handle ~= 0)
            subplot(options.subplot_handle);
            hold on;
        else
            figure(options.figure_handle);
            clf
            hold on
        end

        if (options.f2_label == "")
            t.x_cat = t.(f1_label);
        else
            t.x_cat = string(t.(f1_label)) + ":" + string(t.(options.f2_label));
        end

        t.x_cat = categorical(t.x_cat);
        
        % If there is no grouping label, make a constant column
        if (options.grouping_label == "")
            g = ones(size(t.x_cat));
        else
            g = string(t.(options.grouping_label));
        end

        unique_g = unique(g);
        for i = 1 : numel(unique_g)
            vi = find(g == unique_g(i));
            swarmchart(t.x_cat(vi), t.(data_label)(vi))
        end

    end
end
