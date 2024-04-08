function structure = recursiveStructLoop(structure, trial_name_delete)
    % Loop through each field of the structure
    fields = fieldnames(structure);
    for i = 1:numel(fields)
        field = fields{i};
        value = structure.(field);
        try
            structure.(field) = rmfield( structure.(field), (trial_name_delete));
        catch
        end
        % Check if the value is a struct
        if isstruct(value)
            % If it is a struct, recursively call this function
            recursiveStructLoop(value);
            try
                structure.(field) = rmfield( structure.(field), (trial_name_delete));
            catch
            end
        else
            try
                structure.(field) = rmfield( structure.(field), (trial_name_delete));
            catch
            end
        end
    end
end