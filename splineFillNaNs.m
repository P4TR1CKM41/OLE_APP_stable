function filledArray = splineFillNaNs(inputArray)
    % Ensure the input is a row vector for simplicity.
    if iscolumn(inputArray)
        inputArray = inputArray';
    end
    
    % Find indices of NaNs and non-NaNs.
    nanIndices = isnan(inputArray);
    nonNanIndices = find(~nanIndices);
    nanIndicesToFill = find(nanIndices);
    
    % Check if there are NaNs at the beginning or at the end
    if isempty(nonNanIndices)
        error('The array consists entirely of NaNs.');
    end
    
    % Use spline interpolation to fill NaN values.
    % 'interp1' can handle NaNs at the beginning or at the end by extrapolation if specified.
    filledValues = interp1(nonNanIndices, inputArray(nonNanIndices), nanIndicesToFill, 'spline');
    
    % Create a copy of the inputArray to avoid modifying the original data.
    filledArray = inputArray;
    
    % Replace NaN values with the interpolated values.
    filledArray(nanIndicesToFill) = filledValues;
end