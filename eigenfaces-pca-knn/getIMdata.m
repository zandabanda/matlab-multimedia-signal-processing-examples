function [ X1,X2,X3,X4 ] = getIMdata( datadir )
% ADD X4 AS OUTPUT
% Preallocate matrices to store column stacked image vectors
X1 = zeros(6300,80);
X2 = zeros(1575,80);
X3 = zeros(374,80);
X4 = zeros(63,80); % N=N1xN2, s.t. N1/N2 = 90/70 = 1.28

data = dir(datadir); % reads in files in an odd order, A11-20 come before A1-9

for datum = 1:length(data) % In any MATLAB directory, the actual data start at index 3, the 1st 2 are '.' and '..'
   
    if ((data(datum).bytes > 2900) && (data(datum).bytes < 3200)) % only look at image files of roughly this size in bytes
        
        % Copy and resize images to all sizes we are going to evaluate
        file = data(datum).name; 
        im = double(rgb2gray(imread(file,'jpeg'))); 
        im_45x35 = imresize(im,[45,35]);
        im_22x17 = imresize(im,[22,17]);
        im_9x7 = imresize(im,[9,7]);
    
        % Turn all resized images into vectors, 80 for each size
        im_90x70_v = reshape(im,[6300,1]);
        im_45x35_v = reshape(im_45x35,[1575,1]);
        im_22x17_v = reshape(im_22x17,[374,1]);
        im_9x7_v = reshape(im_9x7,[63,1]);
    
        % Store vectors in matrices.
        X1(:,datum-2) = im_90x70_v; 
        X2(:,datum-2) = im_45x35_v;
        X3(:,datum-2) = im_22x17_v; 
        X4(:,datum-2) = im_9x7_v;
        
    end
end

end

