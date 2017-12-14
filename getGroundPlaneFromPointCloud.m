function [az, ax, H, orientation, location, isUsed, model, planePc, pc_new] = getGroundPlaneFromPointCloud( pc )
%getGroundPlaneFromPointCloud ������ά���ƹ��Ƴ���ƽ�������������
%   pc:     ��ά����

maxDistance = 1;
referenceVector = [0,0,1];
maxAngularDistance = 90;
delta = 0.01

isContinue = true;
isUsed = true;

remainPtCloud = pc;
invalidTform = affine3d;
while isContinue
    % ����ƽ��ģ��
    [model,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud, maxDistance,referenceVector,maxAngularDistance);
    model
    
    planePc = select(pc,inlierIndices);
    remainPtCloud = select(pc,outlierIndices);
    if remainPtCloud.Count < pc.Count*delta
        isUsed = false;
        break;
    end
     tform = getExternalParameterFromPointCloud(model);    % ����ƽ�淨������ȡ��������
     if isequal(tform.T, invalidTform.T)
         H = 0; az = 0; ax = 0; orientation=0; location=0; pc_new=0;
         isUsed = false;
         break;
     end
     pc_new = pctransform(pc, tform);                      % ������ת��Ϊ��������ϵ�µĵ���
    
    orientation = tform.T(1:3, 1:3);                       % ��ȡ��ת����
    location = tform.T(4, 1:3);                            % ��ȡƽ�ƾ���
    
    [az, ax] = getCameraAngle(orientation);
    H = location(3);
    
    %������������
    tformC2W = invert(tform);
    pc_remain_world = pctransform(remainPtCloud, tformC2W);
    pc_plane_world = pctransform(planePc, tformC2W);
    isContinue = ~judgeTheCondition(az, pc_remain_world, pc_plane_world);
end

end

function [isFinish] = judgeTheCondition(az, pc_world, pc_plane)
% judgeTheCondition: �жϵ�ǰƽ���Ƿ�����Ҫ�󣬹�����������Z����ƽ��н�С��45�� &&
% ƽ���ϵĵ�Zֵ����λ����ʣ�������ķ�λ����
% pc_world: ��ȥƽ���ϵĵ��ʣ���
% pc_plane: ƽ���ϵĵ�
% ����ֵ�����������������������isFinish = true�� ���� isFinish=false

if pc_world.Count == 0 || pc_plane.Count == 0
    isFinish = true;
    return ;
end

if abs(az) > pi / 4
    isFinish = false;
    return ;
end

%ͳ��pc_plane ��Zֵ����λ��
word_point_z = prctile(pc_world.Location(:, 3), 50);
plane_point_z = median(pc_plane.Location(:, 3));
if(plane_point_z < word_point_z)
    isFinish = false;
    return ;
end

isFinish = true;
end

function [isUsed] = isCorrectPc(pc, model)
%isCorrectPc  judge whether current model is correct ground
%pc     point cloud
%model  plane model

% get the external parameter from model
% translate pc to world coordinate
% judge current model

end

function [tform] = getExternalParameterFromPointCloud(model)
%getExternalParameterFromPointCloud     get the external parameter from
%plane model 
%model  plane model

param = model.Parameters;
H = param(4);

% get world axis in camera coordinate
oc = [0 0 0]';
ow = getProjectedPoint(oc, model); % ����������ϵԭ����ƽ���ϵ�ͶӰ
zc = [0 0 1]';
yw = getProjectedPoint(zc, model) - ow; %��ȡ������Z����ƽ���ϵ�ͶӰ

if norm(yw) == 0
    tform = affine3d;
    return ;
end

yw = yw/norm(yw);

zw = ow  - oc;
zw = zw / norm(zw);

xw= cross(yw,zw);  % ��������������ȡ

% world coordinate points to camera coordinate points
R = [xw yw zw];
T = -ow'*R;
R =  translate2RigidMatrix(R);
%camera coordinate points to world coordinate points
if sum(sum(isnan(R))) > 0
    tform = affine3d;
    return ;
end
tform = affine3d([R zeros(3, 1);T  1]);
end

function [pp] = getProjectedPoint(p, model)
%getProjectedPoint  get p's projected point pp
%p:     3-D points
%model: plane model

param = model.Parameters;
A = [param(1) param(2) param(3) 0; 1 0 0 param(1); 0 1 0 param(2); 0 0 1 param(3)];
b = [-param(4) p(1) p(2) p(3)]';
pp = A\b;
pp = pp(1:3);
end

function [R t] = rigidTransform3D(A, B)
% rigidTransform3D get transformation between
% cameraPts and worldPts by the corresponding points
% A:    points in camera coordinate
% B:     points in world coordinate
% see: http://nghiaho.com/?page_id=671
% see: http://nghiaho.com/uploads/code/rigid_transform_3D.m

if nargin ~= 2
    error('Missing parameters');
end

%assert(size(A) == size(B))

centroid_A = mean(A);
centroid_B = mean(B);

N = size(A,1);
H = (A - repmat(centroid_A, N, 1))' * (B - repmat(centroid_B, N, 1));
[U,S,V] = svd(H);
R = V*U';
if det(R) < 0
    %printf("Reflection detected\n");
    V(:,3) = V(:,3)*(-1);
    R = V*U';
end

t = -R*centroid_A' + centroid_B'

R = R';
t = t';
end

function [pc_new] = transformPointCloud(pc, tform)
% transformPointCloud: transform point cloud pc to pc_new by tform (didn't
% need rigid matrix)
% note: pctransform can do the same work. but it needs rigid transform
% tform: transformation p*tform.T
% pc: original point cloud

pts = pc.Location;
M = size(pts, 1);
N = size(pts, 2);
A = M*N;
pts = reshape(pts, [A, 3]);
pts = [pts ones(A, 1)];
pts = pts*tform.T;
pts = pts(:, 1:3);
pts = reshape(pts, [M, N, 3]);
pc_new = pointCloud(pts);
end

function [az, ax] = getCameraAngle(orientation)
%getCameraAngle Get the angle of camera.
% orientation:  Camera's orientation (translate points in camera coordinate
% to points in world coordinate.
nw = [0 0 1];   % the ground norm vector
zw = [0 0 1] * orientation;
az = atan2(norm(cross(nw,zw)),dot(nw,zw));

xw = [1 0 0] * orientation;
ax = atan2(norm(cross(nw,xw)),dot(nw,xw)) - pi/2;
end