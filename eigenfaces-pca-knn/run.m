%% Read in Distruted Data Files & Image Preprocessing 

[X1,X2,X3,X4] = getIMdata(pwd); % X2,X3,X4 are raw features 
                                % X1 goes to PCA

%% PCA

P_95 = PCA(80,.95,X1); % feature 2
P_98 = PCA(80,.98,X1); % extra credit
P_90 = PCA(80,.9,X1);
P_rand = PCA_rand(80,.95,X1); % 

%% 5NN and Accuracies

[ac_P_95_5nn_tot,ac_P_95_5nn_A,ac_P_95_5nn_B,ac_P_95_5nn_C,ac_P_95_5nn_D]=knn_im(P_95,5);
[ac_P_98_5nn_tot,ac_P_98_5nn_A,ac_P_98_5nn_B,ac_P_98_5nn_C,ac_P_98_5nn_D]=knn_im(P_98,5);
[ac_P_90_5nn_tot,ac_P_90_5nn_A,ac_P_90_5nn_B,ac_P_90_5nn_C,ac_P_90_5nn_D]=knn_im(P_90,5);
[ac_P_rand_5nn_tot,ac_P_rand_5nn_A,ac_P_rand_5nn_B,ac_P_rand_5nn_C,ac_P_rand_5nn_D]=knn_im(P_rand,5);
[ac_X1_5nn_tot,ac_X1_5nn_A,ac_X1_5nn_B,ac_X1_5nn_C,ac_X1_5nn_D]=knn_im(X1,5);
[ac_X2_5nn_tot,ac_X2_5nn_A,ac_X2_5nn_B,ac_X2_5nn_C,ac_X2_5nn_D]=knn_im(X2,5);
[ac_X3_5nn_tot,ac_X3_5nn_A,ac_X3_5nn_B,ac_X3_5nn_C,ac_X3_5nn_D]=knn_im(X3,5);
[ac_X4_5nn_tot,ac_X4_5nn_A,ac_X4_5nn_B,ac_X4_5nn_C,ac_X4_5nn_D]=knn_im(X4,5);

%% 1NN and Accuracies

[ac_P_95_1nn_tot,ac_P_95_1nn_A,ac_P_95_1nn_B,ac_P_95_1nn_C,ac_P_95_1nn_D]=knn_im(P_95,1);
[ac_P_98_1nn_tot,ac_P_98_1nn_A,ac_P_98_1nn_B,ac_P_98_1nn_C,ac_P_98_1nn_D]=knn_im(P_98,1);
[ac_P_90_1nn_tot,ac_P_90_1nn_A,ac_P_90_1nn_B,ac_P_90_1nn_C,ac_P_90_1nn_D]=knn_im(P_90,1);
[ac_P_rand_1nn_tot,ac_P_rand_1nn_A,ac_P_rand_1nn_B,ac_P_rand_1nn_C,ac_P_rand_1nn_D]=knn_im(P_rand,1);
[ac_X1_1nn_tot,ac_X1_1nn_A,ac_X1_1nn_B,ac_X1_1nn_C,ac_X1_1nn_D]=knn_im(X1,1);
[ac_X2_1nn_tot,ac_X2_1nn_A,ac_X2_1nn_B,ac_X2_1nn_C,ac_X2_1nn_D]=knn_im(X2,1);
[ac_X3_1nn_tot,ac_X3_1nn_A,ac_X3_1nn_B,ac_X3_1nn_C,ac_X3_1nn_D]=knn_im(X3,1);
[ac_X4_1nn_tot,ac_X4_1nn_A,ac_X4_1nn_B,ac_X4_1nn_C,ac_X4_1nn_D]=knn_im(X4,1);
