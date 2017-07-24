function [rotationMatrix, translationVector, imagePoints, isUsed] = getExtrinsicParameters( img, cameraParams )
%getExtrinsicParameters 根据彩色图和相机内参估计相机的姿势.
%   imgC: 彩色视频帧
%   cameraParams: 相机的内参
%   返回相机的旋转矩阵，平移向量，棋盘角点

% 世界坐标
worldPoints = cameraParams.WorldPoints;
% 矫正图像
img = undistortImage(img, cameraParams);
rotationMatrix = [];
translationVector = [];
imagePoints = [];
% 检测棋盘角点
[imagePoints, boardSize] = detectCheckerboardPoints(img);
if (boardSize(1)-1)*(boardSize(2)-1) ~= size(worldPoints, 1)
    isUsed = false;
    warning('dismatched boardSize');
    return ;
end
%根据棋盘角点和对应的世界坐标点计算相机的外参数
[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams);
isUsed = true;
end

