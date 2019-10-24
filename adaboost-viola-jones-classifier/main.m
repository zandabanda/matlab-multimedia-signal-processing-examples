% insert the correct directories
run('/path/to/rects','/path/to/jpg')

%% Load Data
% load first 126 of 162 images, compute their integral images; keep images in RAM
% load allrects.txt, 12 rectangles per image, use last 8 (ignore 1st 4)
cd jpg;
jpgdir = pwd;
contents = dir(jpgdir);
imgs = contents(3:end);
cd ..;

cd rects;
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
%% Compute Features
for trntok = 1:num_trn
    img = imread([jpgdir,'/',imgs(trntok).name]);
    IntImgs_trn(:,:,trntok) = integralimage(img);
end
%% Train with Adaboost
T = 40; % combine T weak classifiers
% create weight vector or matrix 126*8 rectangles, initialize as uniform
wght = ones(num_trn, 8);
lbls = [ones(num_trn,4), zeros(num_trn, 4)]; % assign 0 or 1 to each rectangle SUPERVISED LEARNING (we know correct in advance)

bta = [];
classifiers_weak = zeros(0,9);
% Choose how subrectangles we will search for each image, 6 is a good
% compromise between computational complexity and classifier quality
num_samp = 6;

WHOLE = 1; % controls whether we perform 1 or T training iterations

% Exhaustive search for best T classifiers
for t = 1:(T^WHOLE)
    
    wght=wght/sum(sum(wght)); % renormalize
    bst_wght_err = .51; % Binary classification error can't go above 50%
    
    for xm = 0:(WHOLE*(num_samp-1))
        for ym = 0:(WHOLE*(num_samp-1))
            %disp(sprintf('%d: [%d, %d]',t,xmin,ymin));
            for width = 1:((num_samp-xm)^WHOLE)
                for height = 1:((num_samp-ym)^WHOLE)
                    frac_rect = [xm,ym,width,height]/num_samp;
                    for vert = 0:WHOLE
                        for order = (1+vert):((4-vert)^WHOLE)
                            
                            feat_trn = rectfeature(IntImgs_trn,[trn_rects_pos,trn_rects_neg],frac_rect,order,vert);
                            [theta,pol,err] = bestthreshold(feat_trn,lbls,wght);
                            
                            if err < bst_wght_err
                                bst_classifier = [xm,ym,width,height,vert,order,theta,pol];
                                bst_wght_err = err;
                                %disp(sprintf('%d: [%d, %d, %d, %d], %d, %d: %g < %g with %g, %d',...
                                    %t,xm,ym,width,height,vert,order,err,bst_wght_err,theta,pol));
                            end
                            
                        end
                    end
                end
            end   
        end
    end
    
bta(t) = bst_wght_err/(1-bst_wght_err);
classifiers_weak(t,:) = [bst_classifier, bta(t)];

% recompute features
frac_rect = bst_classifier(1:4)/num_samp;
vert = bst_classifier(5);
order = bst_classifier(6);
theta = bst_classifier(7);
pol = bst_classifier(8);
feat_trn = rectfeature(IntImgs_trn,[rects_pos,rects_neg],frac_rect,order,vert);
        
classifier = (pol*feat_trn < pol*theta); % 0 or 1
% if the classifier is correct, alter the weights; reduce the weights
% corresponding to correctly classified weights.
wght(classifier == lbls) = wght(classifier == lbls)*bta(t);
  
end

if WHOLE
    save('t_classifiers.txt','classifiers','-ascii');
end

%% Testing

T_classifiers = load('t_classifiers.txt','-ascii');
bta = T_classifiers(:,9);
alpha = -log(bta);

% load testing images
for tsttok = (num_trn+1):num_tot
    img = imread([jpgdir,'/',imgs(tsttok).name]);
    IntImgs_tst(:,:,tsttok-num_trn) = integralimage(img);
end

feat_tst = zeros(num_tst,8,T);
classifier_out = zeros(num_tst,8,T);
classifier_strong = zeros(num_tst,8,T);

for t = 1:T
    frac_rect = T_classifiers(t,1:4)/num_samp;
    vert = T_classifiers(t,5);
    order = T_classifiers(t,6);
    theta = T_classifiers(t,7);
    pol = T_classifiers(t,8);
    beta = T_classifiers(t,9);
    feat_tst(:,:,t) = rectfeature(IntImgs_tst,[tst_rects_pos,tst_rects_neg],frac_rect,order,vert);
    classifier_out(:,:,t) = pol*sign(theta - feat_tst(:,:,t));
end    
    
% construct the strong classifier
classifier_strong = cumsum(classifier_out.*repmat(reshape(alpha,[1,1,T]),[num_tst,8]),3);
% signed binary label
lbls_correct = [ones(num_tst,4), -ones(num_tst,4)];


for t = 1:T
    err_tot(t) = mean(mean(sign(classifier_strong(:,:,t)) ~= lbls_correct));
    err_single(t) = mean(mean(sign(classifier_out(:,:,t)) ~= lbls_correct));
end
    
figure();
plot(1:T,err_tot,'*',1:T,err_single,1:T,bta,'o',1:T,alpha,'^');
legend('Total Error','Single Error','betas','alphas')
xlabel('Classifier Step');
ylabel('Error Metrics');

%imshow('testing-performance.png')
