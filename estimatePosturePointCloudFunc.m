function [ az, ax, H, orientation, location, isUsed, pc, model, planePc, pc_new ] = estimatePosturePointCloudFunc( imgD )
%estimatePosturePointCloudFunc 根据深度图估计相机的外参
%   imgD:   输入的深度图
%   返回相机的z轴和x轴与地平面法向量之间的夹角az和ax，相机的高度H，相机的旋转矩阵orientation，平移矩阵location，恢复的三维点云，

% 从深度图中恢复三维点云
pc = niPcFromImage(imgD);

% 根据三维点云，估计地平面，计算相机的外参
[az, ax, H, orientation, location, isUsed, model, planePc, pc_new] = getGroundPlaneFromPointCloud(pc);

end

