function [G] = GuadagnoG(B,A)
%GUADAGNOG Summary of this function goes here
%   Detailed explanation goes here
G = A./(1 + A.*B);
end

