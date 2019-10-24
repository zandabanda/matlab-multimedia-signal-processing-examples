function [ num_trn, num_tst, trn_rects_pos, trn_rects_neg, tst_rects_pos, tst_rects_neg, IntImgs_trn, IntImgs_tst ] = load_dat( jpg_path, rects_path )
% load first 126 of 162 images, compute their integral images; keep images in RAM
% load allrects.txt, 12 rectangles per image, use last 8 (ignore 1st 4)
cd(jpg_path);
jpgdir = pwd;
contents = dir(jpgdir);
imgs = contents(3:end);
cd ..;

cd(rects_path);
rectsdir = pwd;
rects = load('allrects.txt','ascii');
cd ..;

num_tot = length(imgs);
num_trn = round(.75*length(imgs)); % take a fraction to be training examples
num_tst = num_tot - num_trn;

trn_rects_pos = rects(1:num_trn,17:32);
trn_rects_neg = rects(1:num_trn,33:end);
tst_rects_pos = rects(num_trn+1:168,17:32);
tst_rects_neg = rects(num_trn+1:168,33:end);

% load training images
for trntok = 1:num_trn
    img = imread([jpgdir,'/',imgs(trntok).name]);
    IntImgs_trn(:,:,trntok) = integralimage(img);
end

% load testing images
for tsttok = (num_trn+1):num_tot
    img = imread([jpgdir,'/',imgs(tsttok).name]);
    IntImgs_tst(:,:,tsttok-num_trn) = integralimage(img);
end

end

