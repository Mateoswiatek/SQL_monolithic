BEGIN;

SET search_path TO rivers;
SET CONSTRAINTS ALL DEFERRED;

DELETE FROM wojewodztwa;
DELETE FROM powiaty;
DELETE FROM gminy;
DELETE FROM rzeki;
DELETE FROM punkty_pomiarowe;
DELETE FROM pomiary;
DELETE FROM ostrzezenia;

INSERT INTO wojewodztwa values(1,'dolnośląskie');
INSERT INTO wojewodztwa values(2,'kujawsko-pomorskie');
INSERT INTO wojewodztwa values(3,'lubelskie');
INSERT INTO wojewodztwa values(4,'lubuskie');
INSERT INTO wojewodztwa values(5,'łódzkie');
INSERT INTO wojewodztwa values(6,'małopolskie');
INSERT INTO wojewodztwa values(7,'mazowieckie');
INSERT INTO wojewodztwa values(8,'opolskie');
INSERT INTO wojewodztwa values(9,'podkarpackie');
INSERT INTO wojewodztwa values(10,'podlaskie');
INSERT INTO wojewodztwa values(11,'pomorskie');
INSERT INTO wojewodztwa values(12,'sląskie');
INSERT INTO wojewodztwa values(13,'świętokrzyskie');
INSERT INTO wojewodztwa values(14,'warmińsko-mazurskie');
INSERT INTO wojewodztwa values(15,'wielkopolskie');
INSERT INTO wojewodztwa values(16,'zachodniopomorskie');

INSERT INTO powiaty values(1,'krakowski',6);
INSERT INTO powiaty values(2,'brzeski',6);
INSERT INTO powiaty values(3,'chrzanowski',6);
INSERT INTO powiaty values(4,'myślenicki',6);
INSERT INTO powiaty values(5,'miechowski',6);

INSERT INTO powiaty values(6,'pruszkowski',7);
INSERT INTO powiaty values(7,'otwocki',7);
INSERT INTO powiaty values(8,'płocki',7);
INSERT INTO powiaty values(9,'radomski',7);
INSERT INTO powiaty values(10,'warszawski',7);

INSERT INTO powiaty values(11,'bielski',12);
INSERT INTO powiaty values(12,'cieszyński',12);
INSERT INTO powiaty values(13,'częstochowski',12);
INSERT INTO powiaty values(14,'gliwicki',12);
INSERT INTO powiaty values(15,'rybnicki',12);

INSERT INTO powiaty values(16,'wrocławski',1);

INSERT INTO gminy values(1,'Czernichów',1);
INSERT INTO gminy values(2,'Liszki',1);
INSERT INTO gminy values(3,'Skawina',1);
INSERT INTO gminy values(4,'Kraków',1);

INSERT INTO gminy values(5,'Myślenice',4);
INSERT INTO gminy values(6,'Dobczyce',4);
INSERT INTO gminy values(7,'Pcim',4);

INSERT INTO gminy values(8,'Pruszków',6);
INSERT INTO gminy values(9,'Piastów',6);
INSERT INTO gminy values(10,'Michałowice',6);

INSERT INTO gminy values(11,'Pionki',9);
INSERT INTO gminy values(12,'Skaryszew',9);
INSERT INTO gminy values(13,'Zakrzew',9);

INSERT INTO gminy values(14,'Warszawa',10);

INSERT INTO gminy values(15,'Wrocław',16);
INSERT INTO gminy values(16,'Siechnice',16);

INSERT INTO rzeki values(1,'Wisła');
INSERT INTO rzeki values(2,'Odra');
INSERT INTO rzeki values(3,'Nysa Kłodzka');
INSERT INTO rzeki values(4,'Pilica');

INSERT INTO punkty_pomiarowe values(1,10,1,1,24.5678,50.12345,300,500);
INSERT INTO punkty_pomiarowe values(2,11,3,1,24.5678,50.12345,300,500);
INSERT INTO punkty_pomiarowe values(3,12,4,1,24.5678,50.12345,500,800);
INSERT INTO punkty_pomiarowe values(4,13,5,1,24.5678,50.12345,500,800);
INSERT INTO punkty_pomiarowe values(5,14,7,1,24.5678,50.12345,600,800);
INSERT INTO punkty_pomiarowe values(6,15,8,1,24.5678,50.12345,600,800);
INSERT INTO punkty_pomiarowe values(7,16,10,1,24.5678,50.12345,700,900);
INSERT INTO punkty_pomiarowe values(8,17,12,1,24.5678,50.12345,700,900);
INSERT INTO punkty_pomiarowe values(9,18,13,1,24.5678,50.12345,700,900);
INSERT INTO punkty_pomiarowe values(10,19,14,1,24.5678,50.12345,700,1000);

INSERT INTO punkty_pomiarowe values(11,20,15,2,24.5678,50.12345,200,300);
INSERT INTO punkty_pomiarowe values(12,21,15,2,24.5678,50.12345,200,300);
INSERT INTO punkty_pomiarowe values(13,22,15,2,24.5678,50.12345,250,300);
INSERT INTO punkty_pomiarowe values(14,23,16,2,24.5678,50.12345,300,400);
INSERT INTO punkty_pomiarowe values(15,24,16,2,24.5678,50.12345,300,500);

INSERT INTO punkty_pomiarowe values(16,30,15,3,24.5678,50.12345,100,300);
INSERT INTO punkty_pomiarowe values(17,31,16,3,24.5678,50.12345,100,350);

INSERT INTO punkty_pomiarowe values(18,40,16,4,24.5678,50.12345,100,200);
INSERT INTO punkty_pomiarowe values(19,41,16,4,24.5678,50.12345,200,300);
INSERT INTO punkty_pomiarowe values(20,42,16,4,24.5678,50.12345,300,400);
INSERT INTO punkty_pomiarowe values(21,43,16,4,24.5678,50.12345,300,400);

INSERT INTO pomiary values(1,1,'2017-01-23 01:00:00',251);
INSERT INTO pomiary values(2,1,'2017-01-23 02:00:00',270);
INSERT INTO pomiary values(3,1,'2017-01-23 03:00:00',298);
INSERT INTO pomiary values(4,1,'2017-01-23 04:00:00',301);
INSERT INTO pomiary values(5,1,'2017-01-23 05:00:00',301);
INSERT INTO pomiary values(6,1,'2017-01-24 01:00:00',359);
INSERT INTO pomiary values(7,1,'2017-01-24 06:00:00',430);
INSERT INTO pomiary values(8,1,'2017-01-25 03:00:00',530);
INSERT INTO pomiary values(9,1,'2017-01-25 05:00:00',400);
INSERT INTO pomiary values(10,1,'2017-01-25 08:00:00',280);

INSERT INTO pomiary values(11,3,'2017-01-20 01:00:00',300);
INSERT INTO pomiary values(12,3,'2017-01-20 02:00:00',320);
INSERT INTO pomiary values(13,3,'2017-01-20 03:00:00',310);
INSERT INTO pomiary values(14,3,'2017-01-20 04:00:00',330);
INSERT INTO pomiary values(15,3,'2017-01-20 05:00:00',301);
INSERT INTO pomiary values(16,3,'2017-01-20 06:00:00',359);
INSERT INTO pomiary values(17,3,'2017-01-20 07:00:00',430);
INSERT INTO pomiary values(18,3,'2017-01-20 08:00:00',530);
INSERT INTO pomiary values(19,3,'2017-01-20 09:00:00',400);
INSERT INTO pomiary values(20,3,'2017-01-20 10:00:00',300);

INSERT INTO pomiary values(21,5,'2017-01-27 01:00:00',510);
INSERT INTO pomiary values(22,5,'2017-01-27 02:00:00',500);
INSERT INTO pomiary values(23,5,'2017-01-28 03:00:00',500);
INSERT INTO pomiary values(24,5,'2017-01-28 04:00:00',590);
INSERT INTO pomiary values(25,5,'2017-01-29 05:00:00',600);
INSERT INTO pomiary values(26,5,'2017-01-29 06:00:00',670);
INSERT INTO pomiary values(27,5,'2017-01-30 07:00:00',810);
INSERT INTO pomiary values(28,5,'2017-01-30 08:00:00',880);
INSERT INTO pomiary values(29,5,'2017-01-31 09:00:00',680);
INSERT INTO pomiary values(30,5,'2017-01-31 10:00:00',590);

INSERT INTO ostrzezenia values(1,1,'2017-01-23 04:00:00',1,NULL,NULL);
INSERT INTO ostrzezenia values(2,1,'2017-01-23 04:00:00',1,NULL,0);
INSERT INTO ostrzezenia values(3,1,'2017-01-23 04:00:00',59,NULL,58);
INSERT INTO ostrzezenia values(4,1,'2017-01-23 04:00:00',130,NULL,71);
INSERT INTO ostrzezenia values(5,1,'2017-01-23 04:00:00',230,30,100);
INSERT INTO ostrzezenia values(6,1,'2017-01-23 04:00:00',100,NULL,-130);

COMMIT;