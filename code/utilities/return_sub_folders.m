function sub_folders = return_sub_folders(folder_name)
% Returns the sub_folders

if (nargin==1)
    all_values = dir(folder_name);
else
    folder_name = cd;
    all_values = dir;
end

% Restrict to folders
sub_folders = [];
for i = 1 : numel(all_values)
    if (~startsWith(all_values(i).name, '.'))
        test_string = ...
            string(fullfile(all_values(i).folder, ...
                all_values(i).name));
        if (isdir(test_string))
            sub_folders = [sub_folders ; test_string];
        end
    end
end

sub_folders = sort_nat(sub_folders);


    