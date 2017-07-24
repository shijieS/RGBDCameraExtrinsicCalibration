function [ D ] = translate2RigidMatrix( M )
%translate2RigidMatrix translate matrix to rigid matrix
%note: it is an experience to translate the matrix to rigid matrix. firstly
%we translate the matrix to eul angle, then we translate euler angle to
%matrix again.
%   M: the translating matrix
D = eul2rotm(rotm2eul(M));
end

