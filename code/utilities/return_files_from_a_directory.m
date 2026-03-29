function file_list = return_files_from_a_directory(options)

arguments
    options.recursive (1,1) = 0;
end

prompt = {'Enter the file extension you are searching for (Example: xlsx or nd2):'};
title = 'File extension';
field_size = [1 50];
extension = inputdlg(prompt,title,field_size);
extension = char(extension);

if ~isempty(extension)
    folder_name = uigetdir;
    if ~isempty(folder_name)
        file_list = findfiles(extension,folder_name,options.recursive)';
    end
end

if ~exist("file_list","var")
    return
end
end