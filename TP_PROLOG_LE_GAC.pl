/*
	Définition des personnages
	personnage décrit : nom, groupe, fonction, côte de popularité, points d'exp
	ffvii est constitué d'un personnage et de son chef, ex : le chef d'aeris est ifalna, le chef d'ifalna est cloud, ...
*/
ffvii(personnage(aeris,cetras,soin,19,10000),ifalna).
ffvii(personnage(ifalna,cetras,pnj,6,15000),cloud).
ffvii(personnage(cloud,soldat,heros,18,30000),cloud).
ffvii(personnage(tifa,equipe,guerrier,11,15000),barret).
ffvii(personnage(barret,equipe,guerrier,7,14000),cloud).
ffvii(personnage(rougexiii,equipe,soin,18,11000),barret).
ffvii(personnage(yuffie,equipe,ninja,8,2000),barret).


/* 
	groupe : trouver le groupe dans lequel une personne évolue. 
*/
groupe(X,Y) :- ffvii(personnage(X,Y,_,_,_),_).

/* chef : étant donné le nom d'une personne, trouver qui est le chef du groupe dans lequel elle évolue. */
chef(X,Y) :- ffvii(personnage(X,_,_,_,_),Y).

/* 
	membre_valide : la structure de l’équipe étant hiérarchique, on doit pouvoir remonter
	depuis n'importe quel membre vers le chef (Cloud). Le prédicat membre_valide permettra de
	vérifier qu'un membre est bien sous les ordres de Cloud en remontant la chaine hiérarchique. 
*/
membre_valide(cloud).													% Cette ligne sert à s'arrêter lorsque l'on arrive à chef = cloud
membre_valide(X) :- chef(X,Y), membre_valide(Y).

/* 
	xp : donne le niveau d’experience d'un membre 
*/
xp(X,Y) :- ffvii(personnage(X,_,_,_,Y),_).

/* 
	xp_reelle : donne le niveau d’expérience d'un membre en ajoutant au niveau de base un
	bonus, en utilisant les règles suivantes :
	- tous les membres ayant une côte de popularité de 10 ou plus ont un bonus de 5000.
	- Aucun personnage ne peut avoir plus d’expérience que son chef de groupe (attention le cas
	de Cloud est évidemment spécial).
*/
xp_reelle(cloud,Y) :- 								% Cas spécial de cloud
	ffvii(personnage(cloud,_,_,C,E),_),		% On récupère la popularité et l'expérience dans C et E
	C>=10,												% Si la popularité est de 10 ou plus
	Y is E+5000,											% On renvoit l'exp + le bonus
	!.

xp_reelle(X,Y) :- 							% Cas où la popularité >= 10 et exp+bonus <= exp+bonus du chef
	ffvii(personnage(X,_,_,C,E),B),	% On récupère la popularité, l'expérience et le chef dans C, E et B
	C>=10,
	xp_reelle(B,Z),							% Récupération de l'exp avec bonus du chef (dans Z)
	E+5000=<Z,							% Si Z >= exp+bonus
	Y is E+5000.								% On renvoit l'exp + le bonus

xp_reelle(X,Y) :- 							% Cas où la popularité >= 10 et exp+bonus > exp+bonus du chef
	ffvii(personnage(X,_,_,C,E),B),
	C>=10,
	xp_reelle(B,Z),
	E+5000>Z,								% Si Z(exp du chef avec bonus) < exp+bonus
	Y is Z.										% On renvoit seulement l'exp du chef de groupe

xp_reelle(X,Y) :- 							% Cas où la popularité < 10
	ffvii(personnage(X,_,_,C,E),_),
	C=<10,									% Si C < 10
	Y is E.										% On renvoit seulement l'exp

% -----------------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

/* 
	Définir un prédicat factorielle qui calcule la factorielle de N. 
*/

factorielle(0,Y) :- Y is 1.
factorielle(X,Y) :- 
	X>0,												% Si X est supérieur
	X1 is X-1,										% Récupération du chiffre précédent
	factorielle(X1,Z),							% Appel de factorielle sur l'indice précédent
	Y is Z*X,										% Renvoit X multiplié par la factiorielle du chiffre précédent
	concat('', 'Factorielle de ', Log0),	% Affichage du résultat
	concat(Log0, X, Log1),
	concat(Log1, ' = ', Log2),
	concat(Log2, Y, Log3),
	writeln(Log3).

% -----------------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------

/* 
	Suite de Lucas 
*/

% Calcul de la suite récurente linéaire U
suite_u(0,_,_,0).										% 𝑈0(𝑃,𝑄)=0
suite_u(1,_,_,1).										%	𝑈1(𝑃,𝑄)=1
suite_u(N,P,Q,R) :- 									%	𝑈𝑛(𝑃,𝑄)=𝑃𝑈𝑛−1(𝑃,𝑄)−𝑄𝑈𝑛−2(𝑃,𝑄) 𝑝𝑜𝑢𝑟 𝑛>1
	N1 is N-1,
	N2 is N-2,
	suite_u(N1,P,Q,R1),								% Correspond à la partie 𝑈𝑛−1(𝑃,𝑄)
	suite_u(N2,P,Q,R2),								% Correspond à la partie 𝑈𝑛−2(𝑃,𝑄)
	R is (P*R1)-(Q*R2).

% Calcul de la suite récurente linéaire V
suite_v(0,_,_,2).										% 𝑉0(𝑃,𝑄)=2
suite_v(1,P,_,R) :- R is P.							% 𝑉1(𝑃,𝑄)=𝑃
suite_v(N,P,Q,R) :- 									% 𝑉𝑛(𝑃,𝑄)=𝑃𝑉𝑛−1(𝑃,𝑄)−𝑄𝑉𝑛−2(𝑃,𝑄) 𝑝𝑜𝑢𝑟 𝑛>1
	N1 is N-1,
	N2 is N-2,
	suite_v(N1,P,Q,R1),								% Correspond à la partie 𝑉𝑛−1(𝑃,𝑄)
	suite_v(N2,P,Q,R2),								% Correspond à la partie 𝑉𝑛−2(𝑃,𝑄)
	R is (P*R1)-(Q*R2).


%	cas_degeneres : permet de vérifier que P^2 - 4*Q est différent de 0
cas_degeneres(P,Q) :-
	R1 is (P*P)-(4*Q),
	R1=\=0.

	
% Calcul des suites de Lucas
suite_lucas(P,Q) :- 
	cas_degeneres(P,Q),													% Vérification des entrants
	writeln('Renseigner le nombre d''iteration'),
	read(N),
	suite_u(N,P,Q,R1),													% appel de u
	suite_v(N,P,Q,R2),													% appel de v
	concat('U vaut ', R1, Log1),
	writeln(Log1),
	concat('V vaut ', R2, Log2),
	writeln(Log2);
	writeln('CAS DEGENERES !!!'). 									% Si cas_degeneres renvoit false


























