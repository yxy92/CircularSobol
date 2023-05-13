
function [y1,y2] = ToyModel_2(x)
% x= [x1,x2,x3] where xi ~ U(0,2pi)
c = [.2 .4 .8];

y1 = dot(c,x);
y2 = mod(y1,2*pi);
end