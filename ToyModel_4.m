
function y = ToyModel_4(x)
% x= [x1,x2,x3...x10] where xi ~ U(0,2pi)
y = zeros(1,2);
c = .1:.1:1;

y1 = dot(c,x);
y2 = mod(y1,2*pi);

y(1) = y1;
y(2) = y2;
end
