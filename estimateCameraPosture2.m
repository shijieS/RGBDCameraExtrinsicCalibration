clc;clear all;
fileNameC = 'color.avi';
fileNameD = 'depth.mj2';

% using color sensor to get camera's parameter
startTime = 3;          %开始抓取视频帧的时刻(s)
totalImageNum = 30;     %抓取视频帧的总数
gapImageNum = 30;       %抓取视频帧的间隔
size = [7 9];           %棋盘大小为7xm
squareSizeInMM = 40;    %棋盘正方形的长为40mm

% 从视频中从视频的第3s开始，每隔30帧选取30帧视频帧，利用选取的视频帧进行相机内参标定
[ cameraParams, estimationErrors ] = getCameraParameters('color.avi', startTime, 20, 30, [7 9], 40);
worldPoints = cameraParams.WorldPoints;

% 打开视频，并设置当前时间
vc = VideoReader('color.avi');
vc.CurrentTime = 929/ vc.FrameRate;
vd = VideoReader('depth.mj2');
vd.CurrentTime = 929/ vd.FrameRate;

i = 1;
figure;
B = []; C = [];

while hasFrame(vd) && hasFrame(vc)
    %% 根据彩色图估计相机的外参
    imgC = readFrame(vc);
    subplot(2, 3, 1); imshow(imgC);
    [az, ax, H, orientation, location, isUsed, imagePoints] = estimatePostureBoardFunc( imgC, cameraParams );
    B = [B; [rad2deg(az) rad2deg(ax) -H/10]];
    showColorSensorModel(orientation, location, squareSizeInMM, worldPoints, imagePoints, isUsed);
    
    %% 根据深度图估计相机的外参
    imgD = readFrame(vd);
    subplot(2, 3, 2); imshow(imgD, [0 9000]);
    [ az, ax, H, orientation, location, isUsed, pc, model, planePc, pc_new ] = estimatePosturePointCloudFunc( imgD );
    C = [C; [rad2deg(az) rad2deg(ax) -H/10]];
    showDepthSensorModel(location, orientation, pc, model, pc_new, isUsed);
    
    % compare the result error
    showError(B, C);
end
