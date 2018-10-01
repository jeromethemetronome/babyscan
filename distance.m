function [ distance ] = distance( liste1,liste2 )
%DISTANCE Calcule la distance entre les points qui sont dans les deux
%premières colones de liste1 et liste2. 
%   Detailed explanation goes here
distance = sqrt((liste1(:,1)-liste2(:,1)).^2+(liste1(:,2)-liste2(:,2)).^2);
end

