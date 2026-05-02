function filledArray = fillnan3d(inputArray, neighborhoodSize)
    % Fills NaN values in a 3D array with the average of nearest non-NaN neighbors.
    % inputArray: The 3D array containing NaN values.
    % neighborhoodSize: The size of the cubic neighborhood (e.g., 3 for a 3x3x3 cube).

    filledArray = inputArray;
    [rows, cols, pages] = size(inputArray);

    for p = 1:pages
        for r = 1:rows
            for c = 1:cols
                if isnan(filledArray(r, c, p))
                    % Define the neighborhood boundaries
                    r_start = max(1, r - floor(neighborhoodSize / 2));
                    r_end = min(rows, r + floor(neighborhoodSize / 2));
                    c_start = max(1, c - floor(neighborhoodSize / 2));
                    c_end = min(cols, c + floor(neighborhoodSize / 2));
                    p_start = max(1, p - floor(neighborhoodSize / 2));
                    p_end = min(pages, p + floor(neighborhoodSize / 2));

                    % Extract the neighborhood
                    neighborhood = inputArray(r_start:r_end, c_start:c_end, p_start:p_end);

                    % Calculate the mean of non-NaN values in the neighborhood
                    % Use 'omitnan' flag with mean for newer MATLAB versions
                    % For older versions, use nanmean(neighborhood(:))
                    validValues = neighborhood(~isnan(neighborhood));
                    if ~isempty(validValues)
                        filledArray(r, c, p) = mean(validValues);
                    else
                        % Handle cases where the entire neighborhood is NaN
                        % You might choose a different strategy here, e.g., keep NaN
                        % or use a global mean if available.
                        filledArray(r, c, p) = 0; 
                    end
                end
            end
        end
    end
end