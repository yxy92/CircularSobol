
function [y1,y2] = ToyModel_3(x)
% x= [x1,x2,x3] where xi ~ U(0,2pi)

c = [.5 1 2];

y1 = dot(c,x);
y2 = mod(y1,2*pi);
end
