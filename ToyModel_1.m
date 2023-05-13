function [y1,y2] = ToyModel_1(x)
% x= [x1,x2,x3] where xi ~ U(0,2pi)
c = [.2 .4 0];

y1 = dot(c,x);
y2 = mod(y1,2*pi);
end