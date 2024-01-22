

create table wojewodztwa (
	identyfikator	integer primary key,
	nazwa 		varchar(30) not null
);

create table powiaty (
	identyfikator	integer primary key,
	nazwa		varchar(30) not null,
	id_wojewodztwa integer not null references wojewodztwa
);

create table gminy (
	identyfikator	integer primary key,
	nazwa		varchar(30) not null,
	id_powiatu	integer not null references powiaty
);

create table rzeki (
	id_rzeki		integer primary key,
	nazwa		varchar(30) not null
);

create table punkty_pomiarowe (
	id_punktu		integer primary key,
	nr_porzadkowy		integer not null,
	id_gminy		integer not null references gminy,
	id_rzeki		integer not null references rzeki,
	dlugosc_geogr	float,
	szerokosc_geogr float,
	stan_ostrzegawczy integer not null,
	stan_alarmowy integer not null
);

create table pomiary (
	id_pomiaru	integer primary key,
	id_punktu	integer not null references punkty_pomiarowe,
	czas_pomiaru	timestamp not null,
	poziom_wody	integer
);

create table ostrzezenia (
	id_ostrzezenia	integer primary key,
	id_punktu		integer not null references punkty_pomiarowe,
	czas_ostrzezenia timestamp not null,
	przekroczony_stan_ostrz integer,
	przekroczony_stan_alarm integer,
	zmiana_poziomu float
);

insert into wojewodztwa values(1,'dolnośląskie');
insert into wojewodztwa values(2,'kujawsko-pomorskie');
insert into wojewodztwa values(3,'lubelskie');
insert into wojewodztwa values(4,'lubuskie');
insert into wojewodztwa values(5,'łódzkie');
insert into wojewodztwa values(6,'małopolskie');
insert into wojewodztwa values(7,'mazowieckie');
insert into wojewodztwa values(8,'opolskie');
insert into wojewodztwa values(9,'podkarpackie');
insert into wojewodztwa values(10,'podlaskie');
insert into wojewodztwa values(11,'pomorskie');
insert into wojewodztwa values(12,'sląskie');
insert into wojewodztwa values(13,'świętokrzyskie');
insert into wojewodztwa values(14,'warmińsko-mazurskie');
insert into wojewodztwa values(15,'wielkopolskie');
insert into wojewodztwa values(16,'zachodniopomorskie');

insert into powiaty values(1,'krakowski',6);
insert into powiaty values(2,'brzeski',6);
insert into powiaty values(3,'chrzanowski',6);
insert into powiaty values(4,'myślenicki',6);
insert into powiaty values(5,'miechowski',6);

insert into powiaty values(6,'pruszkowski',7);
insert into powiaty values(7,'otwocki',7);
insert into powiaty values(8,'płocki',7);
insert into powiaty values(9,'radomski',7);
insert into powiaty values(10,'warszawski',7);

insert into powiaty values(11,'bielski',12);
insert into powiaty values(12,'cieszyński',12);
insert into powiaty values(13,'częstochowski',12);
insert into powiaty values(14,'gliwicki',12);
insert into powiaty values(15,'rybnicki',12);

insert into powiaty values(16,'wrocławski',1);

insert into gminy values(1,'Czernichów',1);
insert into gminy values(2,'Liszki',1);
insert into gminy values(3,'Skawina',1);
insert into gminy values(4,'Kraków',1);

insert into gminy values(5,'Myślenice',4);
insert into gminy values(6,'Dobczyce',4);
insert into gminy values(7,'Pcim',4);

insert into gminy values(8,'Pruszków',6);
insert into gminy values(9,'Piastów',6);
insert into gminy values(10,'Michałowice',6);

insert into gminy values(11,'Pionki',9);
insert into gminy values(12,'Skaryszew',9);
insert into gminy values(13,'Zakrzew',9);

insert into gminy values(14,'Warszawa',10);

insert into gminy values(15,'Wrocław',16);
insert into gminy values(16,'Siechnice',16);

insert into rzeki values(1,'Wisła');
insert into rzeki values(2,'Odra');
insert into rzeki values(3,'Nysa Kłodzka');
insert into rzeki values(4,'Pilica');

insert into punkty_pomiarowe values(1,10,1,1,24.5678,50.12345,300,500);
insert into punkty_pomiarowe values(2,11,3,1,24.5678,50.12345,300,500);
insert into punkty_pomiarowe values(3,12,4,1,24.5678,50.12345,500,800);
insert into punkty_pomiarowe values(4,13,5,1,24.5678,50.12345,500,800);
insert into punkty_pomiarowe values(5,14,7,1,24.5678,50.12345,600,800);
insert into punkty_pomiarowe values(6,15,8,1,24.5678,50.12345,600,800);
insert into punkty_pomiarowe values(7,16,10,1,24.5678,50.12345,700,900);
insert into punkty_pomiarowe values(8,17,12,1,24.5678,50.12345,700,900);
insert into punkty_pomiarowe values(9,18,13,1,24.5678,50.12345,700,900);
insert into punkty_pomiarowe values(10,19,14,1,24.5678,50.12345,700,1000);

insert into punkty_pomiarowe values(11,20,15,2,24.5678,50.12345,200,300);
insert into punkty_pomiarowe values(12,21,15,2,24.5678,50.12345,200,300);
insert into punkty_pomiarowe values(13,22,15,2,24.5678,50.12345,250,300);
insert into punkty_pomiarowe values(14,23,16,2,24.5678,50.12345,300,400);
insert into punkty_pomiarowe values(15,24,16,2,24.5678,50.12345,300,500);

insert into punkty_pomiarowe values(16,30,15,3,24.5678,50.12345,100,300);
insert into punkty_pomiarowe values(17,31,16,3,24.5678,50.12345,100,350);

insert into punkty_pomiarowe values(18,40,16,4,24.5678,50.12345,100,200);
insert into punkty_pomiarowe values(19,41,16,4,24.5678,50.12345,200,300);
insert into punkty_pomiarowe values(20,42,16,4,24.5678,50.12345,300,400);
insert into punkty_pomiarowe values(21,43,16,4,24.5678,50.12345,300,400);

insert into pomiary values(1,1,'2017-01-23 01:00:00',251);
insert into pomiary values(2,1,'2017-01-23 02:00:00',270);
insert into pomiary values(3,1,'2017-01-23 03:00:00',298);
insert into pomiary values(4,1,'2017-01-23 04:00:00',301);
insert into pomiary values(5,1,'2017-01-23 05:00:00',301);
insert into pomiary values(6,1,'2017-01-24 01:00:00',359);
insert into pomiary values(7,1,'2017-01-24 06:00:00',430);
insert into pomiary values(8,1,'2017-01-25 03:00:00',530);
insert into pomiary values(9,1,'2017-01-25 05:00:00',400);
insert into pomiary values(10,1,'2017-01-25 08:00:00',280);

insert into pomiary values(11,3,'2017-01-20 01:00:00',300);
insert into pomiary values(12,3,'2017-01-20 02:00:00',320);
insert into pomiary values(13,3,'2017-01-20 03:00:00',310);
insert into pomiary values(14,3,'2017-01-20 04:00:00',330);
insert into pomiary values(15,3,'2017-01-20 05:00:00',301);
insert into pomiary values(16,3,'2017-01-20 06:00:00',359);
insert into pomiary values(17,3,'2017-01-20 07:00:00',430);
insert into pomiary values(18,3,'2017-01-20 08:00:00',530);
insert into pomiary values(19,3,'2017-01-20 09:00:00',400);
insert into pomiary values(20,3,'2017-01-20 10:00:00',300);

insert into pomiary values(21,5,'2017-01-27 01:00:00',510);
insert into pomiary values(22,5,'2017-01-27 02:00:00',500);
insert into pomiary values(23,5,'2017-01-28 03:00:00',500);
insert into pomiary values(24,5,'2017-01-28 04:00:00',590);
insert into pomiary values(25,5,'2017-01-29 05:00:00',600);
insert into pomiary values(26,5,'2017-01-29 06:00:00',670);
insert into pomiary values(27,5,'2017-01-30 07:00:00',810);
insert into pomiary values(28,5,'2017-01-30 08:00:00',880);
insert into pomiary values(29,5,'2017-01-31 09:00:00',680);
insert into pomiary values(30,5,'2017-01-31 10:00:00',590);

insert into ostrzezenia values(1,1,'2017-01-23 04:00:00',1,null,null);
insert into ostrzezenia values(2,1,'2017-01-23 04:00:00',1,null,0);
insert into ostrzezenia values(3,1,'2017-01-23 04:00:00',59,null,58);
insert into ostrzezenia values(4,1,'2017-01-23 04:00:00',130,null,71);
insert into ostrzezenia values(5,1,'2017-01-23 04:00:00',230,30,100);
insert into ostrzezenia values(6,1,'2017-01-23 04:00:00',100,null,-130);

