function fdata = invhbtrans(dcoeffs, ccoeffs, transformcell, ind, datacell, datalevel, numofpoints, dimdata)

% Inverse Multilevel transform;
% Reconstruct fdata from coeff and the multilevel
% basis in transformcall

% Reconstruction
numofnodes = size(transformcell, 1);
fdata = zeros(numofpoints, 1, dimdata);


% Up to level 0 of HB coefficients

for n = numofnodes : -1 : 1 
    if isempty(transformcell{n,2}) == 0
        
        ixds = datacell{ind(n)};
        W = transformcell{n,2}; 
       
        
        localfdata = matrixnd(W * conj(dcoeffs{n}'), dimdata);
        fdata(ixds,:,:) = fdata(ixds,:,:) + localfdata;
        
          
        %fdata(ixds) = fdata(ixds) + W * dcoeffs{n}';
         
        
        
    end
end

% Perform zero last level
V = transformcell{1,1};
%fdata = fdata + V * ccoeffs';

fdata = fdata + matrixnd(V * conj(ccoeffs'), dimdata);

