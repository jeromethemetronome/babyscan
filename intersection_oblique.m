function [ x1,y1,x2,y2 ] = intersection_oblique( alpha, beta, x_droite_12, x_droite_34, point1,point2,ymid,y_inter_fit1,y_inter_fit2,y_inter_fit3,y_inter_fit4,sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4,index1, index2, index3, index4, sorted_surf1x,sorted_surf2x,sorted_surf3x,sorted_surf4x)
%INTERSECTION_OBLIQUE Cette fonction calcule les intersection entre les 4
%surfaces de la tête de bébé et les 1 oblique. Il faut donc l'appeler 2
%fois pour calculer les 4 points d'intersection.
%   alpha et beta sont les deux paramètres de la droite de l'oblique
%   x_droite_12 et x_droite_34 sont les coordonnées où on calcule les y
%   des obliques pour une meilleur détection de l'intersection
%   point1 et point2 sont les 2 points références de l'oblique qu'on étudie
%   ici
%   ymid est seulement la référence milieu de y qu'on utilise tout le long
%   du code global
%   toutes les autres entrées sont les données qui permettent de calculer
%   l'intersection avec le fit de la courbe de la tête
% SORTIES : sont les coordonnées des 2 points d'intersection des obiques,
% l'un avec le devant de la tête; l'autre avec le derrière

    y_ob_debut = alpha*x_droite_12+beta; %pour trouver O1

    y_ob_fin = alpha*x_droite_34+beta; %pour trouver O2



if point1(2)<ymid % l'intersection est dans la surface 1
    inter_ob_debut = y_inter_fit1 - y_ob_debut;
    ind_ob_inter_debut = find(abs(inter_ob_debut) == min(abs(inter_ob_debut)));
    y1 = y_ob_debut(ind_ob_inter_debut);
    x1 = interp1(sorted_surf1(index1,2),sorted_surf1x,y1,'pchip');
else % l'intersection est dans la surface 2
    inter_ob_debut = y_inter_fit2 - y_ob_debut;
    ind_ob_inter_debut = find(abs(inter_ob_debut) == min(abs(inter_ob_debut)));
    y1 = y_ob_debut(ind_ob_inter_debut);
    x1 = interp1(sorted_surf2(index2,2),sorted_surf2x,y1,'pchip');
end


%intersection O2
if point2(2)<ymid % l'intersection est dans la surface 4
    inter_ob_fin = y_inter_fit4 - y_ob_fin;
    ind_ob_inter_fin = find(abs(inter_ob_fin) == min(abs(inter_ob_fin)));
    y2 = y_ob_fin(ind_ob_inter_fin);
    x2 = interp1(sorted_surf4(index4,2),sorted_surf4x,y2,'pchip');
else % l'intersection est dans la surface 3
    inter_ob_fin = y_inter_fit3 - y_ob_fin;
    ind_ob_inter_fin = find(abs(inter_ob_fin) == min(abs(inter_ob_fin)));
    y2 = y_ob_fin(ind_ob_inter_fin);
    x2 = interp1(sorted_surf3(index3,2),sorted_surf3x,y2,'pchip');
end

end

