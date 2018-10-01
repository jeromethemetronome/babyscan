function [ datas ] = diagnostique_2( tete_3D , xd,yd,zd, xg,yg,zg, xn,yn,zn, xod,yod,zod, xog,yog,zog, d_yeux_vrai )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%% établissement des variables
% pos_o_d = [xd,yd,zd];
% pos_o_g = [xg,yg,zg];
% pos_n = [xn,yn,zn];
OEIL_DROIT = [xod,yod,zod];
OEIL_GAUCHE = [xog,yog,zog];
d_yeux_matlab = distance(OEIL_DROIT(1:2),OEIL_GAUCHE(1:2));
transition = d_yeux_vrai/d_yeux_matlab ; % on multiplie n'importe quelle longueur matlab par ce facteur
bebe = pcread(tete_3D);
maxi = max(bebe.Location(:,3)); % plus grand z disponible sur la tête du bébé
%%
ref = 2*OEIL_DROIT(3); %on commence à 2*la distance yeux/nez par raport au bout du nez
delta = 0.02; % couche de moins d'un mm ! (0.0534cm)
nbr_coupe = 20; % ce nombre a été choisi arbitrairement
espace = (maxi-ref)/(nbr_coupe+1); %permet de déterminer la distance entre 2 coupes
datas = cell(nbr_coupe,15); % 1 colonne pour le résultat de per_tot (premier resultat de calcul_per), 1 pour la surface totale, 1 pour la position de la coupe (= ref) et 4 pour les 4 rapports qu'on va calculer, 1 pour l'eq de l'oblique 1, une pour l'eq de l'oblique 2, une pour O1,O2,O3,O4, une pour l'eq de AP et une pour P. 
for i = 1:nbr_coupe
    ind = find(bebe.Location(:,3)>=ref & bebe.Location(:,3)<delta+ref);
    surface = bebe.Location(ind,:);
    surface(ind,3) = ref;
    %calcul de périmètre pour chaque surface calculée
    [datas{i,1},datas{i,2},sorted_surf1 , sorted_surf2, sorted_surf3, sorted_surf4,xmin,xmid,xmax,ymin,ymid,ymax] = calcul_per_bis2(surface,transition);
    datas{i,3} = ref*transition;
    
    % projection des oreilles et du nez sur la surface qu'on regarde
    [ OREILLE_DROITE,OREILLE_GAUCHE,I,sorted_surf1x,index1,sorted_surf2x,index2,sorted_surf3x,index3,sorted_surf4x,index4 ] = projection_oreilles_surface( xg,yg,xd,yd,xmin, xmid,xmax,ymin,ymid,ymax,sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4 );
    NEZ = [xmax,yn]; % le nez reste le point à y = 0 donc xmax


    % calculer l'équation de droite AI
    [alphaAB,betaAB] = calcul_eq_droite(I,NEZ);
    datas{i,14} = [alphaAB,betaAB];

    % faire un fit des surfaces 1 à 4 pour trouver l'intersection avec la
    % droite
    surf1_bis = vertcat(sorted_surf4(end-5:end,:),sorted_surf1(:,:),sorted_surf2(1:5,:));
    surf2_bis = vertcat(sorted_surf1(end-5:end,:),sorted_surf2(:,:),sorted_surf3(1:5,:));
    surf3_bis = vertcat(sorted_surf2(end-5:end,:),sorted_surf3(:,:),sorted_surf4(1:5,:));
    surf4_bis = vertcat(sorted_surf3(end-5:end,:),sorted_surf4(:,:),sorted_surf1(1:5,:));

    fit_1 = polyfit(surf1_bis(:,1),surf1_bis(:,2),5);
    fit_2 = polyfit(surf2_bis(:,1),surf2_bis(:,2),5);
    fit_3 = polyfit(surf3_bis(:,1),surf3_bis(:,2),5);
    fit_4 = polyfit(surf4_bis(:,1),surf4_bis(:,2),5);
    
    % faire l'intersection pour trouver P à partir de AI
    [ xP,yP,x_droite_12,x_droite_34,y_inter_fit1,y_inter_fit2,y_inter_fit3,y_inter_fit4 ] = intersection_P( fit_1,fit_2,fit_3,fit_4,alphaAB,betaAB,xmin,xmid,xmax,ymin,ymid,ymax );

    P = [xP,yP];
    datas{i,15} = P;

    % trouver les intersections entre les obliques à 40° avec AP
    % droite oblique - O1O2
    J_ob_1 = [xmax,(I(1)-NEZ(1))*tand(40)];
    [alpha_ob_1,beta_ob_1] = calcul_eq_droite(J_ob_1,I);

    %y_ob_1 = (xmin:0.001:xmax)*alpha_ob_1 + beta_ob_1;
    datas{i,8} = [alpha_ob_1,beta_ob_1];
    J_ob_2 = [xmin, alpha_ob_1*xmin + beta_ob_1];

    % droite oblique - O3O4
    J_ob_3 = [xmax,(I(1)-NEZ(1))*tand(-40)];
    [alpha_ob_2,beta_ob_2] = calcul_eq_droite(J_ob_3,I);

    %y_ob_2 = (xmin:0.001:xmax)*alpha_ob_2 + beta_ob_2;
    datas{i,9} = [alpha_ob_2,beta_ob_2];
    J_ob_4 = [xmin, alpha_ob_2*xmin + beta_ob_2];

    % trouver les points d'intersection entre les obliques et le crâne

    % OBLIQUE 1
    [xO1,yO1,xO2,yO2] = intersection_oblique( alpha_ob_1, beta_ob_1, x_droite_12, x_droite_34, J_ob_1,J_ob_2,ymid,y_inter_fit1,y_inter_fit2,y_inter_fit3,y_inter_fit4,sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4,index1, index2, index3, index4, sorted_surf1x,sorted_surf2x,sorted_surf3x,sorted_surf4x);
    O1 = [xO1,yO1];
    datas{i,10} = O1;
    O2 = [xO2,yO2];
    datas{i,11} = O2;
    % OBLIQUE 2
    [xO3,yO3,xO4,yO4] = intersection_oblique( alpha_ob_2, beta_ob_2, x_droite_12, x_droite_34, J_ob_3,J_ob_4,ymid,y_inter_fit1,y_inter_fit2,y_inter_fit3,y_inter_fit4,sorted_surf1,sorted_surf2,sorted_surf3,sorted_surf4,index1, index2, index3, index4, sorted_surf1x,sorted_surf2x,sorted_surf3x,sorted_surf4x);
    O3 = [xO3,yO3];
    datas{i,12} = O3;
    O4 = [xO4,yO4];
    datas{i,13} = O4;

    % calcul de la distance AP

    AP = distance(NEZ,P)*transition; %distance antéropostérieure (en vrai)

    OGOD = distance(OREILLE_DROITE,OREILLE_GAUCHE)*transition; %distance entre les 2 oreilles (en vrai)

    IC = OGOD/AP * 100;

    datas{i,4} = IC;

    % calcul de la distance O1O2

    O1O2 = distance(O1,O2)*transition;

    O3O4 = distance(O3,O4)*transition;

    oblique_longue = max(O1O2,O3O4);

    oblique_courte = min(O1O2,O3O4);

    ODDI = oblique_longue/oblique_courte*100;
    datas{i,5} = ODDI;

    CVAI = ((oblique_longue-oblique_courte)/oblique_courte)*100;
    datas{i,6} = CVAI;
    
    % calcul de la distance ED

    % droite perpendiculaire à AB qui passe par l'oreille gauche
    beta_og = OREILLE_GAUCHE(2)+1/(alphaAB)*OREILLE_GAUCHE(1);

    beta_od = OREILLE_DROITE(2)+1/(alphaAB)*OREILLE_DROITE(1);

    ED = abs(beta_od-beta_og)/sqrt((1/alphaAB)^2+1)*transition;
    datas{i,7} = ED;
    % on garde le périmètre, la surface et la position de la surface dans
    % chaque ligne de la cell
    
    ref = ref + espace;
    %disp(i)
end

end

