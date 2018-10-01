function [ alpha,beta ] = calcul_eq_droite( point1,point2 )
%CALCUL_EQ_DROITE calcule l'équation de la droite y = alpha*x + beta qui
%passe par les points point1 et point2
%   Detailed explanation goes here
alpha = (point2(2)-point1(2))/(point2(1)-point1(1));
beta = point1(2)-alpha*point1(1);

end

