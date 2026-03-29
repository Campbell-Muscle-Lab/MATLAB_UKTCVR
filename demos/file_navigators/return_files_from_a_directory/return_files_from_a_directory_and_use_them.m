function return_files_from_a_directory_and_use_them


% Let's create some data and save them in Excel files.
% The following pulse waves are taken from
% https://www.mathworks.com/help/signal/ug/signal-generation-and-visualization.html

fs = 10000;
t = 0:1/fs:1.5;
out.pulse_1.time = t';
out.pulse_2.time = t';
out.pulse_1.data = sawtooth(2*pi*50*out.pulse_1.time);
out.pulse_2.data = square(2*pi*50*out.pulse_2.time);

for i = 1 : 2
    var = sprintf('pulse_%i',i);
    out_table = struct2table(out.(var));
    output_file_name = sprintf('demo_files/%s.xlsx',var);
    % Overwriting the old file
    try
        delete(output_file_name)
    end
    writetable(out_table,output_file_name)
end


% Now let's look for Excel files.

file_list = return_files_from_a_directory

% Let's take a look at the data.

d = readtable(file_list{1})

% Let's plot and save the figure.
col = return_matplotlib_default_colors;

for i = 1 : numel(file_list)

    d = [];
    
    d = readtable(file_list{i});

    hold on
    figure(1)
    plot(d.time,d.data,'Color',col(i,:),'LineWidth',2)
    xlim([0 0.2])
    xlabel("Time (sec)")
    ylabel("Amplitude")

end

exportgraphics(gcf,'media/return_files_from_a_directory_and_use_them.png')