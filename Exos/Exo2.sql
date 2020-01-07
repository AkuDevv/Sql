--- Part 1 
create table PIECE (
nop int,
designation varchar(50),
couleur varchar(50),
poids float 
);
create table SERVICE (
nos int,
intitule varchar(50),
localisation varchar(50)
);
create table Ordre (
nop int,
nos int,
quantite int
);
create table NOMENCLATURE (
nopa int,
nopc int,
quantite int
);

--- Part A --- Contraintes d’intégrité ---------
------------1
insert into PIECE (NOP, DESIGNATION, COULEUR, POIDS) values(1,'Designation1','Blanc',15.1);
insert into PIECE (NOP, DESIGNATION, COULEUR, POIDS) values(1,'Designation2','Bleu',13.1);
--Probleme : Les deux tuples sont inserés sans probleme 
-----------2
insert into SERVICE (NOS, INTITULE, LOCALISATION) values(1,'INTITULE1','USA');
insert into SERVICE (NOS, INTITULE, LOCALISATION) values(1,'INTITULE2','Morocco');
--Probleme : Les deux tuples sont inserés sans probleme 
----------3
insert into ORDRE (NOP, NOS, QUANTITE) values(1,2,15);
insert into ORDRE (NOP, NOS, QUANTITE) values(1,3,18);
--Probleme : Les deux tuples sont inserés sans probleme 
----------4
insert into NOMENCLATURE (NOPA, NOPC, QUANTITE) values(1,2,66);
insert into NOMENCLATURE (NOPA, NOPC, QUANTITE) values(1,8,77);
--Probleme : Les deux tuples sont inserés sans probleme 
----------5
alter table piece
add constraint PK_piece primary key(nop);
alter table piece
add constraint FK_piece foreign key (nop) references ordre(nop);
alter table service 
add constraint PK_service primary key(nos);
alter table service
add constraint FK_service foreign key (nop) references ordre(nop);
alter table ordre 
add constraint PK_ordre primary key(nop,nos);
alter table ordre 
add constraint FK1_ordre foreign key (nop) references piece(nop);
alter table ordre 
add constraint FK2_ordre foreign key (nos) references service(nos);
alter table nomenclature 
add constraint pk_nomenclature primary key(nopa);
------------------6
delete  from service where nos in (select distinct nos from service);
delete  from piece where nop in (select distinct nop from piece);
delete  from ordre where nop not in (select distinct nop from piece);
delete  from ordre where nos not in (select distinct nos from service);
------------------7
alter table piece 
add constraint couleur_constraint check (couleur in ('ROUGE','VERTE','BLEUE','JAUNE'));

--- Part C ------- Modification de la structure de la base
------------------------1
alter table piece modify designation varchar(60);
alter table service modify intitule varchar(60);
-----------------------2
alter table service modify localisation varchar(40);
-----------------------3
alter table service 
add directeur varchar(50);
----------------------4
alter table service
drop column localisation;
---------------------5
alter table piece
drop constraint couleur_constraint;
--------------------6
drop table nomenclature;
--------------------7
drop table ordre cascade constraints;
-- Il supprime tous les contraintes d'integrité dans les autres tables.




