function [az, ax, H, orientation, location, isUsed, imagePoints] = estimatePostureBoardFunc( imgC, cameraParams )
%estimatePostureBoardFunc 根据彩色图和相机内参估计相机的姿势.
%   imgC: 彩色视频帧
%   cameraParams: 相机的内参
%   返回相机z轴与平面法向量夹角az，x轴与平面法向量夹角ax，相机的高度H，相机的旋转矩阵orientation，相机在世界坐标系的位置location，

[R, t, imagePoints, isUsed] = getExtrinsicParameters( imgC, cameraParams );
[orientation,location] = extrinsicsToCameraPose(R,t);
[az, ax] = getCameraAngle(orientation);
H = location(3);

end


function [az, ax] = getCameraAngle(orientation)
%getCameraAngle 根据旋转矩阵获得相机的z轴与x轴分别与平面法向量的夹角.
% orientation:  Camera's orientation (translate points in camera coordinate
% to points in world coordinate.
nw = [0 0 1];   % the ground norm vector
zw = [0 0 1] * orientation;
az = atan2(norm(cross(nw,zw)),dot(nw,zw));

xw = [1 0 0] * orientation;
ax = -(atan2(norm(cross(nw,-xw)),dot(nw,-xw)) - pi/2);
end
