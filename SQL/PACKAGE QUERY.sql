
CREATE OR REPLACE PACKAGE query
IS

PROCEDURE numero(numero_corso SMALLINT);
PROCEDURE percentuale;

END query;

/

CREATE OR REPLACE PACKAGE BODY query
IS

PROCEDURE numero(numero_corso SMALLINT) IS



CURSOR cursore IS select l.Numero, l.Argomento, count(u.argvideo) as numero_video, count(u.argtesto) as numero_testo 
                from lezioni l join unitadiapprendimento u on u.NUMERO_LEZIONE = l.Numero
                where l.ID_CORSO = numero_corso            
                group by l.Numero,l.argomento;


Vettore cursore%ROWTYPE;

BEGIN
dbms_output.put_line('NUMERO DI ELEMENTI VIDEO E TESTUALI PER OGNI LEZIONE DI UN CERTO CORSO');

FOR vettore in cursore
LOOP
dbms_output.put_line(vettore.numero ||' '|| vettore.argomento ||' '|| vettore.numero_video ||' '|| vettore.numero_testo);
END LOOP;

END;


PROCEDURE percentuale IS

CURSOR cursore IS select s.Nome,s.Cognome, count(v.ID_CORSO) / count(c.ID) * 100 as Percentuale
                from ((((studenti s join iscrizioni i on s.ID = i.ID_Studente)
                join offerteformative o on (o.ID = i.ID_Offerta))
                join offerteformative_corsi oc on o.ID = (oc.ID_Offerta))
                join corsi c on (c.ID = oc.ID_Corso))
                left join valutazioni v on (v.ID_Corso = c.ID AND v.ID_Studente = s.ID)
                group by (s.ID,s.nome,s.cognome);



Vettore cursore%ROWTYPE;


BEGIN 

dbms_output.put_line('RAPPORTO, PER OGNI STUDENTE, DEI CORSI RECENSITI DIVISO QUELLI ACQUISTATI');

FOR Vettore in cursore
LOOP
dbms_output.put_line(Vettore.nome || ' ' || Vettore.cognome || ' ' || Vettore.percentuale || '%' );
END LOOP;

END;


END query;
