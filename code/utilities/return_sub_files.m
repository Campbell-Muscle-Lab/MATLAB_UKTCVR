function sub_files = return_sub_files(folder_name)
% Returns the sub_folders

if (nargin==1)
    all_values = dir(fullfile(folder_name, '**'));
else
    folder_name = cd;
    all_values = dir('**');
end

% Restrict to folders
sub_files = [];
for i = 1 : numel(all_values)
    if (~startsWith(all_values(i).name, '.'))
        test_string = ...
            string(fullfile(all_values(i).folder, ...
                all_values(i).name));
        if (~isdir(test_string))
            sub_files = [sub_files ; test_string];
        end
    end
end

sub_files = sort_nat(sub_files);


    