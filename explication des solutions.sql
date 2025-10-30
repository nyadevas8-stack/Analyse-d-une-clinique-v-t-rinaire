SAE :Partie 2 : Exploration et extraction des données (Requêtes SQL : ordre SELECT)

1.	Lister tous les clients avec leur nom, localité et département.

select Clinom,Clilocalite,Clidep
from Client


2.	Afficher les informations de tous les médicaments disponibles avec leurs prix.

select Medicament.*
from Medicament

3.	Obtenir les noms et prix des traitements proposés par la clinique

select NomTrai,prixtrai
from traitement

4.	Lister toutes les visites effectuées pour chaque animal, en montrant la date de visite et le type de suivi.

select Visani,Visdate,Vissuivi
from visite

5.	Lister les informations de chaque animal, y compris la race, le sexe et la date de naissance

select  AniId,Anirace,Anisexe,AniDN
from animal

6.	Récupérer les noms des clients et des animaux qu’ils possèdent.

select Client.clinom,Animal.aninom
from client inner join animal
on client.clinum=animal.anicli

7.	Afficher les noms de tous les traitements administrés aux animaux de type « Chat ».

select traitement.nomtrai
from ((traitement inner join detailvisite 
on traitement.codetrai=detailvisite.vistrait)
inner join visite
on detailvisite.visnum=visite.visnum)
inner join animal
on visite.visani=animal.aniId
where Animal.anitype="Chat"

8.	Afficher les informations des animaux mâles 

select animal.*
from animal
where anisexe="M"

9.	Récupérer la liste de tous les clients ayant un site web

SELECT clinum,clinom
from client
where Clisiteweb is not null

10.	Obtenir la liste des animaux stérilisés

select aniid,aninom
from animal 
where anisteril=-1


11.12.	Quels sont les médicaments et les dates de prescription aux chiens ainsi que les différents numéro et nom de chien? (Donner deux solution si c’est possible une avec imbrication de bloc et l’autre sans)

solution 1

select animal.aniid,animal.anitype,animal.aninom,Medicament.mednom
from (((animal inner join visite
on animal.AniId=visite.Visani)
inner join detailvisite
on visite.visnum=detailvisite.visnum)
inner join traitement
on detailvisite.vistrait=traitement.codetrai)
inner join Medicament
on traitement.codetrai=medicament.medcode
where animal.anitype="Chien"

solution 2

select animal.aniid,animal.anitype,animal.aninom,Medicament.mednom
from animal,visite,detailvisite,Medicament,traitement
where  animal.AniId=visite.Visani
and visite.visnum=detailvisite.visnum
and detailvisite.vistrait=traitement.codetrai
and traitement.codetrai=medicament.medcode
where animal.anitype="Chien"

12.	Quels sont les animaux n’ayant jamais eu de traitement?

select animal.aniid,animal.aninom
from (((animal left  join visite
on animal.AniId=visite.Visani)
left join detailvisite
on visite.visnum=detailvisite.visnum)
left join traitement
on detailvisite.vistrait=traitement.codetrai)
where  codetrai is null


13.	Quels sont les animaux n’ayant pas eu de visite


select animal.aniid,animal.aninom
from animal left  join visite
on animal.AniId=visite.Visani
where visnum is null

14.	Donner pour chaque animal, son nom, sa race, et les différentes dates de visite à la clinique deux cas suivants 

a.	faire figurer dans le résultat de la requête que les animaux qui ont eu au moins une visite

select animal.aninom,animal.Anirace,visite.visdate
from animal inner join visite
on animal.AniId=visite.Visani

b.	faire figurer dans le résultat de la requête tous les animaux

select animal.aninom,animal.Anirace,visite.visdate
from animal left join visite
on animal.AniId=visite.Visani

15.Lister les traitements coûtant plus d’un prix de 500.

select nomtrai,prixtrai
from traitement
where prixtrai > 500
order by prixtrai;

16.	Récupérer tous les clients ayant une remise supérieure  20
select client.*
from client 
where cliremise > 0.2

#meme si les remises sont en pourcentages sur sql acess utilise la notation decimal ou la virgule est representée par le point 0.2


17.Afficher les animaux décédés avec leur nom, type et date de naissance.

select aninom,anitype,AniDN
from animal 
where anidecede=-1

18.Lister les clients enregistrés dans la clinique depuis plus de cinq ans.

select Client.*,
datediff("yyyy",Clidepuis,date()) as ancienete
from client
where datediff("yyyy",Clidepuis,date()) > 


19.Trouver tous les animaux de type « Chien » pesant plus de 50 kilos

select animal.*
from animal
where anipoids > 50
and anitype="chien"

20.	Afficher les médicaments dont le prix est inférieur à la moyenne des prix

select medcode,mednom,avg(medprix) as Prix_moyenmed
from medicament 
group by medcode,mednom
HAVING AVG(medprix) < (SELECT AVG(medprix) FROM medicament);

#group by vient avant le HAVING
# ne pas utilise where pour agregat
#il faut savoir que l'agregatavg,som sont considere comme de nouvelle table d'une ligne qui renvoie une valeur unique  donc il faut imperativement appeller toute la table (select avg/sum ...) pour faire des comparaison qui linclu

21.	Récupérer les visites pour lesquelles le paiement a été effectué en liquide.

select visite.*
from visite inner join paiement
on visite.vistypepaie=paiement.paitypecode
where paitypelib="Espèces"

22.	Lister les animaux avec un commentaire associé dans leur fiche.
select animal.*
from animal 
where anicommentaires is not null


23.Trouver les nimaux ayant des propriétaires dans un département 30

select animal.*
from animal inner join client 
on animal.anicli=client.clinum
where Cint(Clidep)=30

#convertion des données 

24.	Compter le nombre total d animaux traités par la clinique

select count(*) as nombre_animal
from animal 

25.Calculer le coût total des médicaments disponibles.

select sum(medprix) as coût_total_des_médicaments
from medicament

26.Récupérer le nombre de clients par département

SELECT clidep,count(*) as nb_client
from Client 
group by clidep

27.Calculer la durée moyenne de vie des animaux dans la base.

select avg(datediff("yyyy",AniDN,date())) as moyenne_de_vie
from animal
where anidecede=-1

28.	Trouver le nombre total de visites réalisées pour chaque animal.

select aniid,aninom,count(visnum) as nbvisit
from visite inner join animal 
on animal.aniid=visite.visani
group by aniid,aninom


29.	Afficher le nombre de médicaments administrés par visite.
select visani,count(vismed) as nb_medicament
from visite inner join detailvisite
on visite.visnum=detailvisite.visnum
group by Visani

30.Calculer le nombre moyen de traitements par visite pour chaque animal

select round(avg(nb_traitement),2) as nb_moyen_traitement
from(select visite.visnum,count(vistrait) as nb_traitement
from detailvisite inner join visite
on detailvisite.visnum=visite.visnum
group by visite.visnum) as nombre_traitement

#les ous réquete peuvent sutiliser dans le from pour effectuer des calculer intermediaire qui serviront dans la requete princupale
puis qu on ne combine pas des agrégations 
etapes
1) ecrire les requete qui permet de calculer lelement intermediaire mettre les parenthese au debut et a la fin
de la requete puis la nommer
2)ecrire la requete principale qui va utiliser se resultat (par la biais du nom de la requete intermediaire) dans le select


31.Calculer le chiffre daffaires total généré par les traitements

select sum(nb_traitement*PrixTrai) as CA
from traitement,(select NomTrai,count(vistrait) as nb_traitement
from detailvisite inner join traitement
on detailvisite.vistrait=traitement.codetrai
group by NomTrai) as nombretrai_par_typedetraitement

#crée une premiere sous requete qui va compter en groupant par les noms  le nombre de traitement au total durant les visites pour chaque nom de traitement 
# ensuite la requete principale va faire la somme du produit (prix et le nombre total de traitement suivant le nom du traitement)

32.Afficher la somme des remises accordées à chaque client
select clinum,sum((client.cliremise)*(Medprix+prixtrai)) as cout_total
from ((((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai) 
inner join medicament on detailvisite.vismed=medicament.medcode
group by clinum

il faut faire une jointure externe pour voir les clients dont les animaux  nayant pas recu  de visite napparaitront pas pourtant il peuvent avoir une remise 
donc on aura des espaces vides 

33.	Récupérer le coût total des médicaments administrés aux chats

select round(sum(cout_totalchaquechat),2) as cout_total_des_chats
from (select aniid,anitype,aninom,sum((client.cliremise)*Medprix) as cout_totalchaquechat
from (((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani ) 
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join medicament on detailvisite.vismed=medicament.medcode
where anitype="Chat"
group by aniid,anitype,aninom) as Coutmed_chaquechat 

creation d une sous requete qui va calculer le cout des medicament d un seul chat ensuite la requete principale va calculer  le cout total

34.	Afficher les noms des animaux et les noms de leurs propriétaires.

select animal.aninom,client.clinom
from client inner join animal 
on client.clinum=animal.anicli

35.Récupérer les noms des clients et les types d'animaux qu'ils possèdent

select client.clinom,animal.anitype
from client inner join animal 
on client.clinum=animal.anicli


36.Afficher les noms des animaux et les traitements qu’ils ont reçus.

select animal.aninom,Traitement.nomtrai
from ((animal inner join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai


37.Obtenir le nom de chaque client et le nombre de visites qu’il a effectuées.

select client.clinom,count(visite.visnum) as nb_vis
from ((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani ) 
group by client.clinom
order by 2


38.Lister les médicaments prescrits lors des visites, en incluant les détails de chaque visite.

select mednom,visnum,detailvisite.*
from (visite inner join detailvisite
on visite.visnum=detailvisite.visnum) 
inner join medicament on detailvisite.vismed=medicament.medcode


39.Afficher les clients avec leur localité et le nombre d'animaux qu'ils possèdent.

select client.clinum,client.Clilocalite,count(animal.aniid) as nb_animal
from animal inner join client 
on animal.anicli=client.clinum
group by client.clinum,client.Clilocalite
order by 3

40.Récupérer les noms des clients et les visites effectuées pour chacun de leurs animaux.

select client.clinom,visnum
from (client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani 

41.Afficher les détails de toutes les visites avec les traitements administrés et médicaments utilisés.

select detailvisite.*,nomtrai,mednom
from (detailvisite 
inner join medicament on detailvisite.vismed=medicament.medcode)
inner join traitement on detailvisite.vistrait=traitement.codetrai

42.Obtenir la liste des clients avec le montant total de leurs factures de visites.

select clinum,round(sum((1-client.cliremise)*(Medprix+prixtrai)),2) as cout_total
from ((((client
left   join Animal on client.clinum=animal.anicli)
left  join visite on animal.aniid=visite.visani )
left join detailvisite on visite.visnum=detailvisite.visnum) 
left  join traitement on detailvisite.vistrait=traitement.codetrai) 
left  join medicament on detailvisite.vismed=medicament.medcode
group by clinum

43.Récupérer la liste des visites et des médicaments prescrits pour chaque visite.
(voir la prof)
select visite.*,mednom
from visite inner join medicament 
on visite.vismed=medicament.medcode

44.Trouver les noms des clients dont le nom commence par la lettre « M ».

select Clinom
from client 
where clinom like "M*"

45.Afficher les médicaments administrés à des animaux  d’un type cheval.
select anitype,medicament.*
from (animal inner join visit 
on animal.aniid=visite.Visani)
inner join Medicament
on visite.vismed=medicament.medcode
where anitype="Cheval"

46.Lister les visites de suivi effectuées après le premier semestre 2020

select visite.*,datepart("yyyy",visdate) as Année
datepart("q",VisDate) as semestre
from visite 
where datepart("q",VisDate)>2
and datepart("yyyy",visdate)=2020
parce que un semestre est constitue de  de deux semestre donc semestre 2 cest le 3 eme et 4 eme semestre

47.Récupérer les clients ayant au moins deux animaux.

select count(Aniid) as nb_animaux,Client.Clinum,Client.clinom
from Client inner join animal 
on client.clinum=animal.anicli
group by Client.Clinum,Client.clinom
having count(Aniid)>=2
order by 1

having vient aprés le group by 

48.Afficher les clients ayant une balance de compte négative

select client.*
from (client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani 
where visdatepaiement is null

49.Trouver tous les animaux ayant reçu un traitement spécifique de votre choix(Crupo (injectio
select Aniid,aninom
from ((Animal 
inner  join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai
where NomTrai="Exploration rectale"

50.Lister les animaux nés avant une année de votre choix(2019)
select annid ,aninom,datepart("yyyy",anidn) as AnnéeDN
from animal 
where datepart("yyyy",anidn)<2019

51.Trouver les clients dont les animaux ont été traités avec un médicament spécifique.(Aspertane - 400 mg)

select mednom,clinum,clinom
from ((((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai) 
inner join medicament on detailvisite.vismed=medicament.medcode
where mednom="Aspertane - 400 mg"

52.Afficher les clients ayant effectué au moins une visite au cours du dernier mois

select clinum,clinom,count(visnum) as nbvisite,datepart("m",visdate)
from ((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani )
where datepart("m",visdate)=12
group by clinum,clinom,datepart("m",visdate)
having count(visnum)>=1

ordre(where,group by,having)

53.Obtenir la liste des clients qui nont effectué aucune visite depuis leur enregistrement.
(a revoir)
select clinum,clinom
from ((client
left  join Animal on client.clinum=animal.anicli)
left join visite on animal.aniid=visite.visani )
where visnum is null

ici utiliser left join pour pourvoir compter les clients qui nont pas de correspondance dans la table visite

54.Trouver les clients ayant effectué le plus grand nombre de visites (top 5).

select Top 5 clinum,clinom,count(visnum) as nbvisite
from ((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani )
group by clinum,clinom
order by  3 desc 



55.Requête pour déterminer les animaux ayant eu plus de trois traitements différents en un an.

select,count(codetrai)
from (select DISTINCT nomtrai
from traitement),((Animal 
inner  join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai
group by AniId,aninom

je vaix dabords ecrire une requete qui va afficher le nom des animaux avec les noms des traitements quils on fait sans repetition du nom

(select  DISTINCT datepart("yyyy",visite.visdatesuivi),traitement.nomtrai,visite.visdatesuivi,animal.Aniid,animal.aninom
from ((Animal 
inner  join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai) as Traitementdiff_ani

il ya creation dune sous table nommee Traitementdiff_ani qui affiche chaque animal avec les traaitement different recu par an  

jecris une requete principale qui va maitenant compte les traitement de chaque animaux 
se
select datepart ("yyyy", Traitementdiff.visdatesuivi) AS année,Traitementdiff.AniId,Traitementdiff.aninom,count(Traitementdiff.codetrai) AS nb_traitement
from( select distinct traitement.codetrai,animal.AniId,animal.aninom,visite.visdatesuivi
from ((Animal inner join visite ON animal.aniid = visite.visani)
inner join detailvisite ON visite.visnum = detailvisite.visnum)
inner join traitement ON detailvisite.vistrait = traitement.codetrai)AS Traitementdiff
group by  datepart("yyyy", Traitementdiff.visdatesuivi),Traitementdiff.AniId, Traitementdiff.aninom
having count(Traitementdiff.codetrai) > 3
order by 4

1h15 MIN maiintenant trouver comment ajouter le par an

select datesuivi
from visite
where visani="PR001-03" on remarque qu il a eu une visite en 2021 et 2020 donc il faut bien separe les année dans la  repartition des traitement


56.Calcul du chiffre d’affaires par trimestre de l année 2021, pour chaque type de traitement.


premiere etape ecrire la sous requete qui va permettre de calculer le nombre de traitement effectuer par type 
ensuite ecrire la requete principale qui join les table detailvisite et traitement  les visite et la sous requete  puis que les element utilise dans le select provien de ces tables 
lasoous requete aura pour cle primaire lelement affiher par celle si nomtrai donc elle est jointe avec la table traitement 
cest pourquoi on a on nbtraitementpartype.nomtrai = traitement.nomtrai
et enfin mettre les critere donc grouper par trismettre avec date part  et par type 
sans oublier que l année cest 2021  on obtient donc
select nbtraitementpartype.NomTrai,datepart("yyyy",visite.visdatesuivi) as annéeTrai,datepart("q",visite.visdatesuivi) as trimestre, sum(nb_traitement*PrixTrai) as CA
from (((detailvisite inner join traitement on detailvisite.vistrait=traitement.codetrai)
inner join visite on detailvisite.visnum=visite.visnum)
inner join (select Traitement.nomtrai,count(Vistrait) as nb_traitement
 from detailvisite inner join traitement
on detailvisite.vistrait=traitement.codetrai
group by  traitement.nomtrai) as nbtraitementpartype
on nbtraitementpartype.nomtrai = traitement.nomtrai)
where datepart("yyyy",visite.visdatesuivi)=2021 
group by nbtraitementpartype.NomTrai,datepart("q",visite.visdatesuivi),datepart("yyyy",visite.visdatesuivi)
order by datepart("yyyy",visite.visdatesuivi),
datepart("q",visite.visdatesuivi) asc


50 min 

57.Requête donnant la liste des animaux ayant pris le même médicament plus de trois fois dans lannée.

ecrire une  requete qui compte le nombre de fois qu un meme medicament est pris par un animal (grouper par med code et nom animal et par Année)
et avec un having on  va alors extraire les animaux ayant consomme le medicament plus de 3 fois


select aninom,mednom,count(medcode) as nbdeprise,datepart("yyyy",visdatesuivi) as annéeTrai
from (((Animal 
inner  join visite on animal.aniid=visite.visani )
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join traitement on detailvisite.vistrait=traitement.codetrai)
inner  join medicament on detailvisite.vismed=medicament.medcode
group by aninom,mednom,datepart("yyyy",visdatesuivi)
having count(medcode)>3
order by 3,
4;

58.Requête pour calculer le coût total des traitements administrés pour la clinique  sur une période donnée.
considerons de 15/01/ 2021 a 12/02/2022



select round(sum(cout_total),2) as cout_totalsurcetteperiode
from visite,(select aniid,anitype,aninom,sum(Medprix) as cout_total
from (((client
inner  join Animal on client.clinum=animal.anicli)
inner  join visite on animal.aniid=visite.visani ) 
inner join detailvisite on visite.visnum=detailvisite.visnum) 
inner join medicament on detailvisite.vismed=medicament.medcode
group by aniid,anitype,aninom) as Coutmed_chaquechat 
WHERE visdatesuivi BETWEEN #2021-01-15# AND #2022-02-12#