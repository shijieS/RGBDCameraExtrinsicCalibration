clc;clear all;
fileNameC = 'color.avi';
fileNameD = 'depth.mj2';

% using color sensor to get camera's parameter
startTime = 3;          %��ʼץȡ��Ƶ֡��ʱ��(s)
totalImageNum = 30;     %ץȡ��Ƶ֡������
gapImageNum = 30;       %ץȡ��Ƶ֡�ļ��
size = [7 9];           %���̴�СΪ7xm
squareSizeInMM = 40;    %���������εĳ�Ϊ40mm

% ����Ƶ�д���Ƶ�ĵ�3s��ʼ��ÿ��30֡ѡȡ30֡��Ƶ֡������ѡȡ����Ƶ֡��������ڲα궨
[ cameraParams, estimationErrors ] = getCameraParameters('color.avi', startTime, 20, 30, [7 9], 40);
worldPoints = cameraParams.WorldPoints;

% ����Ƶ�������õ�ǰʱ��
vc = VideoReader('color.avi');
vc.CurrentTime = 929/ vc.FrameRate;
vd = VideoReader('depth.mj2');
vd.CurrentTime = 929/ vd.FrameRate;

i = 1;
% figure;
B = []; C = []; X=[];

if hasFrame(vd) && hasFrame(vc)
    %% ���ݲ�ɫͼ������������
    imgC = readFrame(vc);     

    [az, ax, H, orientation, location, isUsed, imagePoints] = estimatePostureBoardFunc( imgC, cameraParams );
    B = [B; [rad2deg(az) rad2deg(ax) -H/10]];

    
    %% �������ͼ������������
    imgD = readFrame(vd);
   figure
    for i = 1:0.5:40
        i
        imageProcess = imgD;
%         imageProcess = addNoise(imageProcess, 'salt & pepper', i/100.0);
         imageProcess = addNoise(imageProcess, 'gaussian', i/100.0);
%         imshow(imageProcess, [0, 5000])
        [ az, ax, H, orientation, location, isUsed, pc, model, planePc, pc_new ] = estimatePosturePointCloudFunc( imageProcess );
        if ~isUsed
            continue
        end
        
        C = [C; [rad2deg(az) rad2deg(ax) -H/10]];
        X = [X; i/100.0];
%         subplot(1,2,1);
%         imshow(imageProcess, [0, 9000])
%         subplot(1,2,2);
        showError(B, C, X);
        pause(0.01)
    end
    
end


function showError(B, C, X)
subplot(2, 3, 6);
D = abs(B - C);
% x = 1:size(D, 1);
y1 = D(:, 1);
y2 = D(:, 2);
y3 = D(:, 3);
plot(X, y1, 'r-',X, y2, 'g-', X, y3, 'b-');
legend('\Delta\theta', '\Delta\phi', '\Delta H');
end

function img = addNoise(img, type, r)
minP = double(min(img(:)));
maxP = double(max(img(:)));
img = (double(img) - minP) ./ (maxP-minP);
% img = imnoise(img, 'gaussian', r);
img = imnoise(img, type, r);
img = uint16(img.*(maxP-minP)+minP);
end