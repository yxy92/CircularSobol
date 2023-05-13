
function [y1,y2] = ToyModel_4(x)
% x= [x1,x2,x3...x10] where xi ~ U(0,2pi)
c = .1:.1:1;

y1 = dot(c,x);
y2 = mod(y1,2*pi);
end
