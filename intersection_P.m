function [ xP,yP,x_droite_12,x_droite_34,y_inter_fit1,y_inter_fit2,y_inter_fit3,y_inter_fit4 ] = intersection_P( fit_1,fit_2,fit_3,fit_4,alphaAB,betaAB,xmin,xmid,xmax,ymin,ymid,ymax )
%INTERSECTION_P Permet de calculer l'intersection entre la droite AI et le
%derrière de la tête pour trouver le point Postérieur
%   on donne d'abord les expressions des fits pour les 4 parties de la tête
%   alphaAB et betaAB sont les paramètres de la droite AI
%   le reste sont les coordonées de référence en x et y de la tête
% SORTIES les coordonnées xP et yP sont les coordonnées du point d'intérêt
% le reste sont des y calculés des fits qui serviront pour les autres
% fonctions.

% trouver l'intersection entre la droite et la parabole en testant chaque
% zone et si ça ne rentre pas dans l'intervalle des x y e la zone testée

x_droite_12 = (xmid:0.001:xmax);
x_droite_34 = (xmin:0.001:xmid);
y_droite_12 = alphaAB*x_droite_12 + betaAB;
y_droite_34 = alphaAB*x_droite_34 + betaAB;

y_inter_fit1 = polyval(fit_1,x_droite_12);
inter_1 = y_inter_fit1-y_droite_12;
y_inter_fit2 = polyval(fit_2,x_droite_12);
inter_2 = y_inter_fit2-y_droite_12;
y_inter_fit3 = polyval(fit_3,x_droite_34);
inter_3 = y_inter_fit3-y_droite_34;
y_inter_fit4 = polyval(fit_4,x_droite_34);
inter_4 = y_inter_fit4-y_droite_34;

ind_inter_1 = find(abs(inter_1) == min(abs(inter_1)));
ind_inter_2 = find(abs(inter_2) == min(abs(inter_2)));
ind_inter_3 = find(abs(inter_3) == min(abs(inter_3)));
ind_inter_4 = find(abs(inter_4) == min(abs(inter_4)));

ind_inter_tot = [ind_inter_1,ind_inter_2,ind_inter_3,ind_inter_4];

position_surface = find(ind_inter_tot == min(ind_inter_tot)); % nous donne dans quelle surface se trouve l'intersection

% comment on retrouve la position de l'intersection

if position_surface == 1
    yP = y_droite_12(ind_inter_1);
    xP = interp1(y_droite_12,x_droite_12,yP);
elseif position_surface == 2
    yP = y_droite_12(ind_inter_2);
    xP = interp1(y_droite_12,x_droite_12,yP);
elseif position_surface == 3
    yP = y_droite_34(ind_inter_3);
    xP = interp1(y_droite_34,x_droite_34,yP);
else
    yP = y_droite_34(ind_inter_4);
    xP = interp1(y_droite_34,x_droite_34,yP);
end


end

