--DROPPO TUTTO
drop table feedback;
drop table iscrizioni;
drop table offerteformative_corsi;
drop table unitadiapprendimento;
drop table valutazioni;
drop table lezioni;
drop table studenti;
drop table offerteformative;
drop table corsi;
drop table docenti;

--CREO TUTTO
create table Studenti(
ID int,
Nome varchar2(50) not null,
Cognome Varchar2(50) not null,
CodFiscale varchar2(16) not null,
Email varchar2(100) not null,
Password varchar2(32) not null,
Username varchar2(20) not null,
Saldo number not null,

constraint PK_STUDENTI primary key(ID),
constraint VALIDITA_MAIL_STUDENTI check (Email like '__%@__%.__%' and Email not like '%@%@%'),
constraint HASHED_PWD_STU check (LENGTH(Password) = 32),
constraint LEN_CF_STU check (LENGTH(CodFiscale) = 16)
);

create table Docenti (
ID int,
Nome varchar2(50) not null,
Cognome Varchar2(50) not null,
CodFiscale varchar2(16) not null,
Email varchar2(100) not null,
Password varchar2(32) not null,
Ruolo varchar2(20) not null,
Curriculum blob not null,

constraint PK_DOCENTI primary key(ID),
constraint VALIDITA_MAIL_DOCENTI check (Email like '__%@__%.__%' and Email not like '%@%@%'),
constraint HASHED_PWD_DOC check (LENGTH(Password) = 32),
constraint LEN_CF_DOC check (LENGTH(CodFiscale) = 16)
);

create table Corsi (
ID int,
Nome varchar2(50) not null,
ID_Docente int not null,
Descrizione varchar2(500)  not null,

constraint PK_CORSI primary key (ID)
);

create table Lezioni (
Numero smallint,
ID_Corso int,
Argomento Varchar2(100) not null,


constraint PK_LEZIONI primary key (Numero, ID_Corso)
);

create table OfferteFormative(
	ID int,
	Prezzo float not null,
	Info varchar2(500) not null,
	
constraint PK_OFFERTEFORMATIVE primary key (ID)
);


create table UnitaDiApprendimento(
Numero int,
Numero_Lezione smallint,
ID_Corso int,
ArgVideo varchar2(100),
ArgTesto varchar2(100),

constraint PK_UNITADIAPPRENDIMENTO primary key (Numero, Numero_Lezione, ID_Corso),
constraint VALIDITA_PAGINA check ((ArgVideo is null and ArgTesto is not null) or (ArgTesto is null and ArgVideo is not null)) 
);


create table Valutazioni (
ID_Corso int,
ID_Studente int,
Testo Varchar2(500) not null,

Constraint PK_VALUTAZIONI primary key (ID_Studente, ID_Corso)
);

create table Feedback (
Numero_Lezione int,
ID_Corso int,
ID_Studente int,
Stelle int  not null,

constraint PK_FEEDBACK primary key (Numero_Lezione, ID_Corso, ID_Studente),
constraint NUM_STELLE check (Stelle > 0 and  Stelle < 6)
);

create table Iscrizioni(
ID_Offerta int,
ID_Studente int,
data date not null,

constraint PK_ISCRIZIONI primary key (ID_Offerta,  ID_Studente)
);

create table OfferteFormative_Corsi(
ID_Corso int, 
ID_Offerta int,

constraint PK_OFFORMATIVE_CORSI primary key (ID_Offerta,  ID_Corso)
);

ALTER TABLE Lezioni 
ADD CONSTRAINT FK_LEZIONI_CORSI FOREIGN KEY (ID_Corso) 
REFERENCES Corsi(ID) 
ON DELETE CASCADE;

 

ALTER TABLE Corsi 
ADD CONSTRAINT FK_CORSI_DOCENTI FOREIGN KEY (ID_Docente) 
REFERENCES Docenti(ID);
--Per poter eliminare un docente è necessario gestire i corsi creati dallo stesso (Non c'è "ON DELETE CASCADE")
 


ALTER TABLE UnitaDiApprendimento 
ADD CONSTRAINT FK_UNITAPPR_LEZIONI FOREIGN KEY (Numero_Lezione, ID_Corso) 
REFERENCES Lezioni(Numero, ID_Corso) 
ON DELETE CASCADE;

 

ALTER TABLE Feedback 
ADD CONSTRAINT FK_FEEDBACK_LEZIONI FOREIGN KEY (Numero_Lezione, ID_Corso) 
REFERENCES Lezioni(Numero, ID_Corso) 
ON DELETE CASCADE;

 

ALTER TABLE Feedback 
ADD CONSTRAINT FK_FEEDBACK_STUDENTI FOREIGN KEY (ID_Studente) 
REFERENCES Studenti(ID) 
ON DELETE CASCADE;

 

ALTER TABLE OfferteFormative_Corsi 
ADD CONSTRAINT FK_OFFORM_CORSI FOREIGN KEY (ID_Corso) 
REFERENCES Corsi(ID) 
ON DELETE CASCADE;

 

ALTER TABLE OfferteFormative_Corsi 
ADD CONSTRAINT FK_OFFORM_OFF FOREIGN KEY (ID_Offerta) 
REFERENCES OfferteFormative(ID) 
ON DELETE CASCADE;

 

ALTER TABLE Iscrizioni 
ADD CONSTRAINT FK_ISCRIZIONI_OFF FOREIGN KEY (ID_Offerta) 
REFERENCES OfferteFormative(ID) 
ON DELETE CASCADE;

 

ALTER TABLE Iscrizioni 
ADD CONSTRAINT FK_ISCRIZIONI_STUDENTI FOREIGN KEY (ID_Studente) 
REFERENCES Studenti(ID) 
ON DELETE CASCADE;

 

ALTER TABLE Valutazioni 
ADD CONSTRAINT FK_VALUTAZIONI_STUDENTI FOREIGN KEY (ID_Studente)  
REFERENCES Studenti(ID) 
ON DELETE CASCADE;

 

ALTER TABLE Valutazioni 
ADD CONSTRAINT FK_VALUTAZIONI_CORSI FOREIGN KEY (ID_Corso)  
REFERENCES Corsi(ID) 
ON DELETE CASCADE;

