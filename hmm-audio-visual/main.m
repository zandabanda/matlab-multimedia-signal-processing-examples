%% Run whole file
[avg_acc_audio, avg_acc_video, avg_acc_audio_visual] = run('/path/to/AV_DATA');

%% Run in pieces
%% Load Features
[audio_visual_2, audio_visual_5, audio_2, ~, audio_5, ~, video_2, ~, video_5, ~ ] = load_feat('AV_DATA');
N=5;
a = [.5, .5, 0, 0, 0];
Ainit = [a; circshift(a,1,2); circshift(a,2,2); circshift(a,3,2); 0, 0, 0, 0, 1];

%% Test HMM Audio
[avg_acc_audio] = test_HMM2(audio_2, audio_5, N, Ainit);

%% Test HMM Video
[avg_acc_video] = test_HMM2(video_2, video_5, N, Ainit);

%% Test HMM Audio-VIsual
[avg_acc_audio_visual] = test_HMM2(audio_visual_2, audio_visual_5, N, Ainit);

%% Plot table of results

figure();
tables = imread('accuracy.png');
imagesc(tables);
