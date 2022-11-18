-- PARTICIPANT TYPES

declare @metaParticipantTypes table (
  participant_type_id int, 
  key_name varchar(50), 
  name_fr varchar(50), 
  name_nl varchar(50)
)

insert into @metaParticipantTypes(participant_type_id, key_name, name_fr, name_nl)
values
(1,	'belgian-study-participant',	'Etude belge',	'Belgische studie'),
(2,	'foreign-study-participant',	'Etude étrangère',	'Buitenlandse studie'),
(3,	'private-person-participant',	'Personne privée', 	'Privépersoon / particulier'),
(4,	'bailiff-participant',	'Huissier de justice', 'Gerechtsdeurwaarder'),
(5,	'court-participant',	'Tribunal',	'Rechtscollege'),
(6,	'fodfin-participant',	'SPF Finances',	'FOD Financiën'),
(7,	'legal-person-participant',	'Autre entité juridique',	'Andere rechtspersoon'),
(8,	'fednot-admin-participant',	'Fednot Service Support',	'Fednot steundienst'),
(9,	'arert-participant',	'ARERT',	'ARERT'),
(10,	'public-government-participant',	'Gouvernement ou institution publique',	'Openbare overheid of instelling')

insert into crt.participant_type(participant_type_id, key_name, name_fr, name_nl)
select participant_type_id, key_name, name_fr, name_nl 
from @metaParticipantTypes
where participant_type_id not in (select participant_type_id from crt.participant_type)

update crt.participant_type 
set key_name = m.key_name, name_fr = m.name_fr, name_nl = m.name_nl
from crt.participant_type pt
inner join @metaParticipantTypes m
	on m.participant_type_id = pt.participant_type_id

-- DOSSIER CONTEXTS

declare @metaDossierContexts as table(
	dossier_context_id int, 
	key_name varchar(50), 
	name_fr varchar(50), 
	name_nl varchar(50), 
	apply_gdpr_shielding tinyint, 
	allow_manual_selection tinyint)
insert into @metaDossierContexts(dossier_context_id, key_name, name_fr, name_nl, apply_gdpr_shielding, allow_manual_selection)
values
(1,	'FAMILY_SUCCESSION',	'Planification successorale familiale',	'Familiale vermogensplanning',	1,	1),
(2,	'LIQUIDATION_OF_LEGACY',	'Consultation générale',	'Algemene consultatie',	1,	1),
(3,	'PROVEN_IMPORTANCE',	'Importance démontrée',	'Aangetoond belang',	1,	1),
(4,	'EXTENDED_SEARCH',	'Autorisation pour une consultation approfondie',	'Machtiging tot uitgebreide opzoeking',	0,	1),
(5,	'PERSONAL_RIGHT_OF_INSPECTION',	'Droit personnel',	'Persoonlijk inzagerecht',	1,	1),
(6,	'OFFICE_SPECIFIC_ACCESS',	'Accès spécifique au bureau',	'Ambtspecifieke toegang',	1,	1),
(7,	NULL,	'ARERT Consultation wills',	'ARERT Consultation wills',	1,	1),
(8, NULL, 'Fodfin - importance démontrée', 'Fodfin - Aangetood belang', 1, 1)



-- LEGAL ACT TYPES

declare @metaRegistrationTypes table (
	registration_type_id int,
	name varchar(50),
	register_type_id int,
	code varchar(2),
	definition varchar(50),
	name_fr varchar(200),
	name_nl varchar(200),
	send_to_naban tinyint,
	requires_repertory tinyint,
	restricted_person_state varchar(20),
	publication_bog_required varchar(20),
	publication_bog_type varchar(50)
)

insert into @metaRegistrationTypes
values
(1,'SUCCESSION_AGREEMENT',1,'60','succession-agreement','Pacte successoral (clauses Valkeniers depuis 1/09/2018 inclus)','Erfovereenkomst (inclusief de Valkeniersbedingen sinds 1/09/2018)',0,1,null,'NO',null),
(2,'AUTHENTIC_TESTAMENT',1,'10','one-declarer','Testament authentique','Authentiek testament',1,1,'ALIVE','NO',null),
(3,'OWN_TESTAMENT',1,'20','own-testament','Testament olographe','Eigenhandig testament',0,0,null,'NO',null),
(4,'OWN_TESTAMENT_AFTER_DECEASE',1,'25','one-declarer','Testament olographe après décès','Eigenhandig testament na overlijden',0,0,'DECEASED','NO',null),
(5,'DECLARATION_OF_PRESERVATION',1,'30','one-declarer','Déclaration de maintien','Verklaring van behoud',0,1,null,'NO',null),
(6,'CONTRACTUAL_APPOINTMENT_OF_HEIR',1,'40','one-declarer','Institution contractuelle et donations entre époux de biens futurs','Contractuele erfstelling en giften tussen echtgenoten van toekomstige goederen',1,1,null,'NO',null),
(7,'INTERNATIONAL_TESTAMENT',1,'70','one-declarer','Testament international','Internationaal testament',1,1,null,'NO',null),
(8,'PRIOR_AGREEMENT',1,'80','one-declarer','Convention préalable ou postérieur au divorce qui déroge aux dispositions antérieures concernant la dévolution successorale','Voorafgaande overeenkomst of overeenkomst volgend op de echtscheiding die een afwijking inhoudt betreffende de al gedane regeling van de erfrechtelijke devolutie',0,1,null,'NO',null),
(9,'OTHER_DEEDS_THAT_CAN_HAVE_INFLUENCE',1,'90','other-crt-deed','Autres actes qui ont un impact sur la dévolution successorale','Andere akten die een invloed kunnen hebben op de erfrechtelijke devolutie',0,0,null,'NO',null),
(10,'VALKENIERS',1,'50','one-declarer','Clauses ''Valkeniers'' (jusqu''au 31/08/2018) et avantages matrimoniaux sous condition de survie','''Valkeniers'' bedingen (tem 31/08/2018) en huwelijksvoordelen onder voorwaarde van overleven',0,1,null,'NO',null),
(11,'REVOCATION',1,'99','one-declarer','Revocation','Herroeping',0,1,null,'NO',null),
(12,'COHABITATION_AGREEMENT',2,'20','two-declarers','Contrat de cohabitation légale (art. 1478 Code Civile)','Samenlevingsovereenkomst (art. 1478 Burgerlijk Wetboek)',0,1,null,'NO',null),
(13,'DECLARATION_ANTICIPATORY_INPUT',2,'30','two-declarers','Déclaration d''apport anticipé','Verklaring van anticipatieve inbreng',0,1,null,'NO',null),
(14,'WEDDING_CONTRACT',2,'10','marriage-contract','Contrat de mariage','Huwelijksovereenkomst',0,1,null,'NO',null),
(15,'DEED_MODIFICATION_WEDDING_SYSTEM',2,'15','change-marriage-contract','Acte modificatif du contrat de marriage','Wijzigingsakte huwelijksovereenkomst',0,1,null,'NO',null),
(16,'JUDGEMENT',2,'80','crh-judgment-arrest','Jugement','Vonnis',0,1,null,'NO',null),
(17,'ARREST',2,'90','crh-judgment-arrest','Arrêt','Arrest',0,1,null,'NO',null),
(18,'SUCCESSION_DEED',3,'10','cer-testator','Acte d''hérédité - jusqu''à 01/04/2021','Akte van erfopvolging - tot 01/04/2023',0,1,null,'NO',null),
(19,'SUCCESSION_CERTIFICATE',3,'30','cer-testator-and-inheritors','Certificat d''hérédité','Attest van erfopvolging',0,1,null,'NO',null),
(20,'EUROPEAN_SUCCESSION_CERTIFICATE',3,'40','cer-testator','Certificat successoral européen','Europese erfrechtverklaring',0,1,null,'NO',null),
(21,'STATEMENT_OF_REJECTION',3,'50','cer-inheritor-declaration','Déclaration de renonciation','Verklaring van verwerping',0,1,null,'NO',null),
(22,'STATEMENT_OF_ACCEPTATION_UNDER_INVENTORY',3,'60','cer-inheritor-declaration','Déclaration d''acceptation sous bénéfice d''inventaire','Verklaring van aanvaarding onder voorrecht van boedelbeschrijving',0,1,null,'YES','PUBLICATION_BOG_LANGUAGE_AND_DOMICILE'),
(23,'CER_JUDGEMENT_ARREST',3,'70','cer-judgment-arrest','Désignation d''un curateur ou administrateur','Aanwijzing curator of beheerder',0,1,null,'NO',null),
(24,'SUCCESSION_DEED_MOVABLE',3,'15','cer-testator-and-inheritors','Acte d''hérédité - mobilier - depuis 01/04/2023','Akte van erfopvolging - roerend - vanaf 01/04/2023',0,1,null,'NO',null),
(25,'SUCCESSION_DEED_IMMOVABLE',3,'20','cer-testator-and-inheritors','Acte d''hérédité - immobilier - depuis 01/04/2023','Akte van erfopvolging - onroerend - vanaf 01/04/2023',0,1,null,'NO',null),
(26,'SUCCESSION_DEED_MIXED',3,'25','cer-testator-and-inheritors','Acte d''hérédité - mixte - depuis 01/04/2023','Akte van erfopvolging - gemengd - vanaf 01/04/2023',0,1,null,'NO',null),
(27,'SUCCESSION_CERTIFICATE',3,'31','cer-testator','Certificat d''hérédité - sans héritiers','Attest van erfopvolging - zonder erfgenamen',0,1,null,'NO',null),
(28,'SUCCESSION_DEED_MOVABLE',3,'16','cer-testator','Acte d''hérédité - mobilier - depuis 01/04/2023 - sans héritiers','Akte van erfopvolging - roerend - vanaf 01/04/2023 - zonder erfgenamen',0,1,null,'NO',null),
(29,'SUCCESSION_DEED_IMMOVABLE',3,'21','cer-testator','Acte d''hérédité - immobilier - depuis 01/04/2023 - sans héritiers','Akte van erfopvolging - onroerend - vanaf 01/04/2023 - zonder erfgenamen',0,1,null,'NO',null),
(30,'SUCCESSION_DEED_MIXED',3,'26','cer-testator','Acte d''hérédité - mixte - depuis 01/04/2023 - sans héritiers','Akte van erfopvolging - gemengd - vanaf 01/04/2023 - zonder erfgenamen',0,1,null,'NO',null)

insert into crt.registration_type(registration_type_id, name, register_type_id, code, definition, name_fr, name_nl, send_to_naban, requires_repertory, restricted_person_state, publication_bog_required, publication_bog_type )
select registration_type_id, name, register_type_id, code, definition, name_fr, name_nl, send_to_naban, requires_repertory, restricted_person_state, publication_bog_required, publication_bog_type 
from @metaRegistrationTypes
where registration_type_id not in (select registration_type_id from crt.registration_type)

update crt.registration_type
set name = n.name, register_type_id = n.register_type_id, code = n.code, definition = n.definition, name_fr = n.name_fr, name_nl = n.name_nl, send_to_naban = n.send_to_naban, requires_repertory = n.requires_repertory, restricted_person_state = n.restricted_person_state, publication_bog_required = n.publication_bog_required, publication_bog_type = n.publication_bog_type
from crt.registration_type o
inner join @metaRegistrationTypes n
	on o.registration_type_id = n.registration_type_id


-- update participants that can register what legal acts

declare @metaRegistrantLegalActTypes table(
 participant_type_id int,
 registration_type_id int
)

insert into @metaRegistrantLegalActTypes(participant_type_id, registration_type_id)
values
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 18),
(2, 19),
(2, 20),
(2, 21),
(2, 22),
(2, 24),
(2, 25),
(2, 26),
(2, 27),
(2, 28),
(2, 29),
(2, 30),
(5, 16),
(5, 17),
(5, 20),
(5, 23),
(6, 19),
(6, 24),
(6, 25),
(6, 26),
(6, 27),
(6, 28),
(6, 29),
(6, 30)


delete from crt.participant_type_registration_type

insert into crt.participant_type_registration_type(participant_type_id, registration_type_id)
select participant_type_id, registration_type_id
from @metaRegistrantLegalActTypes

