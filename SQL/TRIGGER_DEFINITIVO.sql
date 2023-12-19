CREATE OR REPLACE TRIGGER feedback_lezione_studente
BEFORE INSERT ON feedback
FOR EACH ROW

DECLARE
non_iscritto EXCEPTION; --eccezione
NUMISCR INTEGER;        --contatore

BEGIN
--conto in quante offertete formative a cui lo studente e'  iscritto
--e'presente il corso che contiene la lezione a cui si vuole inserire il feedback

SELECT COUNT(*) INTO NUMISCR 
FROM (offerteformative o JOIN offerteformative_corsi oc ON (oc.ID_Offerta = o.ID))
JOIN iscrizioni i ON i.ID_Offerta = oc.id_offerta
WHERE (oc.ID_Corso = :new.ID_Corso AND i.ID_Studente = :new.ID_Studente);

IF NUMISCR <= 0 THEN    --controllo contatore
    RAISE non_iscritto;
END IF;

EXCEPTION
WHEN non_iscritto THEN raise_application_error(-20003, 'Studente non iscritto');
END;

/

CREATE OR REPLACE TRIGGER valutazione_corso_studente
BEFORE INSERT ON Valutazioni
FOR EACH ROW 			--trigger di tupla

DECLARE
non_iscritto EXCEPTION; --contatore
NUMISCR INTEGER;

BEGIN
SELECT COUNT(*) INTO NUMISCR 
FROM (((Studenti d join iscrizioni i ON (d.ID = i.ID_Studente))
JOIN offerteformative o ON (o.ID = i.ID_offerta))
JOIN offerteformative_corsi oc ON (oc.ID_Offerta = o.ID))
JOIN corsi c ON (c.ID = oc.ID_Corso)
WHERE d.ID = :new.ID_Studente AND c.ID = :new.ID_Corso;

IF NUMISCR = 0 THEN
    RAISE non_iscritto;
END IF;

EXCEPTION
WHEN non_iscritto THEN raise_application_error(-20069, 'Studente non iscritto');
END;

/

create or replace trigger numero_lezioni_crescente
before insert on Lezioni
for each row
declare
non_crescente exception;
NUM_LEZIONE constant Lezioni.Numero%TYPE := :new.Numero;
CORSO constant Lezioni.ID_Corso%TYPE := :new.ID_Corso;
LEZIONE_PRECEDENTE integer;
var integer;
begin
IF( NUM_LEZIONE <> 1 ) THEN
    SELECT count(l.Numero) into LEZIONE_PRECEDENTE
    FROM lezioni l
    where l.ID_Corso = CORSO;
    IF(LEZIONE_PRECEDENTE <> NUM_LEZIONE - 1) THEN
        raise non_crescente;
    END IF;
END IF;

exception
when non_crescente then raise_application_error(-20003, 'Inserire le lezioni in ordine crescente!');
end;

