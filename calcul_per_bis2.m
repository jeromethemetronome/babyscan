function [ per_tot, surf_tot , sorted_surf1 , sorted_surf2, sorted_surf3, sorted_surf4,xmin,xmid,xmax,ymin,ymid,ymax] = calcul_per_bis2(surface,transition)
%CALCUL_PER Permet de calculer le périmètre total de la surface donnée au
%programme
%   surface est une matrice à 2 colonnes, x et y. les "sorted_surfaces"
%   sont les surfaces avec les points bien rangés par la fonction ranger_les_points.
%   surf_tot est l'array avec tous les points rangés dans l'ordre pour
%   faire le tour de la tête
xmax = max(surface(:,1));
xmin = min(surface(:,1));
xmid = (xmax+xmin)/2;
ymax = max(surface(:,2));
ymin = min(surface(:,2));
ymid = (ymax+ymin)/2;

per_tot = 0;

ind1 = find(surface(:,1)>=xmid & surface(:,1)<=xmax & surface(:,2)>=ymin & surface(:,2)<=ymid); %entre x=0 et x max, ymin et y = 0
surf1 = surface(ind1,:);
if length(surf1) > 1000
    surf1 = unique(surf1(:,:),'rows'); % on fait cette étape pour enlever les points qui ont les mêmes coordonnées, donc qui ne servent pas au calcul de périmètre, et qui rajoutent du temps de calcul
end

ind2 = find(surface(:,1)>=xmid & surface(:,1)<=xmax & surface(:,2)>=ymid & surface(:,2)<=ymax); %entre x = 0 et xmax, y = 0 et ymax
surf2 = surface(ind2,:);
if length(surf2) > 1000
    surf2 = unique(surf2(:,:),'rows');
end

ind3 = find(surface(:,1)>=xmin & surface(:,1)<=xmid & surface(:,2)>=ymid & surface(:,2)<=ymax); %entre xmin et x = 0, y = 0 et ymax
surf3 = surface(ind3,:);
if length(surf3) > 1000
    surf3 = unique(surf3(:,:),'rows');
end

ind4 = find(surface(:,1)>=xmin & surface(:,1)<=xmid & surface(:,2)>=ymin & surface(:,2)<=ymid); %entre xmin et x = 0, ymin et y = 0
surf4 = surface(ind4,:);
if length(surf4) > 1000
    surf4 = unique(surf4(:,:),'rows');
end


sorted_surf4 = ranger_les_points(surf4(:,:),[xmin,ymid]);
sorted_surf1 = ranger_les_points(surf1(:,:),[xmid,ymin]);
sorted_surf2 = ranger_les_points(surf2(:,:),[xmax,ymid]);
sorted_surf3 = ranger_les_points(surf3(:,:),[xmid,ymax]);

surf_tot = vertcat(sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4);
surf_tot = double(surf_tot);
surf_tot(:,1) = surf_tot(:,1)*transition;
surf_tot(:,2) = surf_tot(:,2)*transition;

for i = 1:length(surf_tot)-1
   per_tot =  per_tot + sqrt((surf_tot(i+1,1)-surf_tot(i,1))^2 + (surf_tot(i+1,2)-surf_tot(i,2))^2);
end
per_tot = (per_tot + sqrt((surf_tot(1,1)-surf_tot(end,1))^2 + (surf_tot(1,2)-surf_tot(end,2))^2))*transition;% calcule le dernier bout de périmètre entre le dernier point et le premier, puis multiplie par "transition" pour avoir une sortie en cm
end


