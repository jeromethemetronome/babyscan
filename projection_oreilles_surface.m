function [ OREILLE_DROITE,OREILLE_GAUCHE,I,sorted_surf1x,index1,sorted_surf2x,index2,sorted_surf3x,index3,sorted_surf4x,index4 ] = projection_oreilles_surface( xg,yg,xd,yd,xmin, xmid,xmax,ymin,ymid,ymax,sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4 )
%PROJECTION_OREILLES_SURFACE Permet de calculer les nouvelles coordonnées
%des oreilles sur la nouvelle coupe du cerveau par rapport à leur position
%réelle
%   xg,yg,xd,yd,xmin, xmid,xmax,ymin,ymid,ymax sont les coordonées des
%   oreilles (gauche et droite) et les coordonnées de référence en x et y
%   sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4 sont les arrays
%   triés dans le bon sens
% SORTIES : OREILLE_DROITE et OREILLE_GAUCHE sont les nouvelles coordonnées
% des oreilles, I sont les coordonnées du point au milieu des oreilles, le
% reste sert pour plus tard


[sorted_surf1x,index1] = unique(sorted_surf1(:,1));
[sorted_surf2x,index2] = unique(sorted_surf2(:,1));
[sorted_surf3x,index3] = unique(sorted_surf3(:,1));
[sorted_surf4x,index4] = unique(sorted_surf4(:,1));

if xg >xmid && xg<=xmax+5 && yg >=ymin-5 && yg <=ymid
    yg_new = interp1(sorted_surf1x,sorted_surf1(index1,2),xg,'pchip');
elseif xg >xmid && xg<=xmax+5 && yg >ymid && yg <=ymax +5
    yg_new = interp1(sorted_surf2x,sorted_surf2bis(index2,2),xg,'pchip');
elseif xg >=xmin-5 && xg<=xmid && yg >ymid && yg <=ymax+5
    yg_new = interp1(sorted_surf3x,sorted_surf3bis(index3,2),xg,'pchip');
else
    yg_new = interp1(sorted_surf4x,sorted_surf4(index4,2),xg,'pchip');
end

if xd >xmid && xd<=xmax+5 && yd >=ymin-5 && yd <=ymid
    yd_new = interp1(sorted_surf1x,sorted_surf1(index1,2),xd,'pchip');
elseif xd >xmid && xd <=xmax+5 && yd >ymid && yd <=ymax+5
    yd_new = interp1(sorted_surf2x,sorted_surf2bis(index2,2),xd,'pchip');
elseif xd >=xmin-5 && xd <=xmid && yd >ymid && yd <=ymax+5
    yd_new = interp1(sorted_surf3x,sorted_surf3bis(index3,2),xd,'pchip');
else
    yd_new = interp1(sorted_surf4x,sorted_surf4(index4,2),xd,'pchip');
end

OREILLE_DROITE = [xd,yd_new];

OREILLE_GAUCHE = [xg,yg_new];

I = (OREILLE_DROITE + OREILLE_GAUCHE)/2; %coordonnées du point I

end

