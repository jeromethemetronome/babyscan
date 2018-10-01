function [ sorted_surf ] = ranger_les_points(surface,ref)
%UNTITLED4 Summary of this function goes here
%   s'utilise seulement pour nos surfaces !!
    % surface 1 : xmid<x<xmax, ymin<y<ymid
    % surface 2 : xmid<x<xmax, ymid<y<ymax
    % surface 3 : xmin<x<xmid, ymid<y<ymax
    % surface 4 : xmin<x<xmid, ymin<y<ymid
% on cherche le point le plus proche de xmid pour la surface 1 pour
% commencer la liste, le point le plus proche de xmax pour surface 2, celui
% proche de xmid pour la surface 3, le plus proche de xmin pour la surface
% 4
len = length(surface);

sorted_surf = zeros(len,3);

tableau_ind = zeros(1,len);

% remplir la première entrée
indice = 1;
mini = distance(surface(1,1:2),ref);
for i = 2:len
    if distance(surface(i,1:2),ref)<mini
        mini = distance(surface(i,1:2),ref);
        indice = i;
    end
end

sorted_surf(1,:) = surface(indice,:);
tableau_ind(1,1) = indice;

% il faut chercher dans tous les indices sauf celui qu'on a déjà pris
for i = 2:len % fait la boucle pour rentrer les valeurs dans sorted_surf
    indice = 1;
    mini = 100;
    for j = 1:len % cherche dans toute la liste surface pour trouver la plus petite distance
       if isempty(find(tableau_ind == j,1)) == 1 && distance(surface(j,1:2),sorted_surf(i-1,1:2))<mini % ce point n'a pas encore été classé dans sorted_surf
           mini = distance(surface(j,1:2),sorted_surf(i-1,1:2));
           indice = j;
       end
    %disp(indice)  
    end
    sorted_surf(i,:) = surface(indice,:);
    tableau_ind(i,1) = indice;
end
sorted_surf = double(sorted_surf);
end
