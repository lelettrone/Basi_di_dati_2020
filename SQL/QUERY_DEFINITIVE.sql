--tutti i corsi associati per ogni docente

select d.Nome, d.Cognome, c.Nome as Nome_Corso
from docenti d join corsi c
on c.ID_DOCENTE = d.ID;

--numero di video e testo per ogni lezione di un certo corso

select l.Numero as NUMERO_LEZIONE, l.Argomento, count(u.argvideo) as numero_video, count(u.argtesto) as numero_testo 
from lezioni l join unitadiapprendimento u on u.NUMERO_LEZIONE = l.Numero
where l.ID_CORSO = 1 --ID Del corso di interesse
group by l.Numero,l.argomento

--Percentuale di corsi che ha recesito ciascuno studente

select s.Nome,s.Cognome, count(v.ID_CORSO) / count(c.ID) * 100 as Percentuale
from ((((studenti s join iscrizioni i on s.ID = i.ID_Studente)
join offerteformative o on (o.ID = i.ID_Offerta))
join offerteformative_corsi oc on o.ID = (oc.ID_Offerta))
join corsi c on (c.ID = oc.ID_Corso))
left join valutazioni v on (v.ID_Corso = c.ID AND v.ID_Studente = s.ID)
group by (s.ID,s.nome,s.cognome)

-- Il/I docente/i che ha pubblicato più corsi di tutti

select d.nome,d.cognome, count(c.ID) as numero_corsi
from docenti d join corsi c on c.ID_Docente = d.ID
group by (d.id, d.nome, d.cognome)
having count(c.ID) =
(
select max(count(c1.ID))
from docenti d1 join corsi c1 on c1.ID_Docente = d1.ID
group by (d1.id)
)

--corsi dove la valutazione media delle lezioni è maggiore o uguale di 4 stelle

select  c.ID, c.nome, avg(f.stelle) AS MEDIA
from 
(corsi c join lezioni l on l.ID_CORSO = c.id)
join feedback f on f.ID_CORSO = l.ID_CORSO and f.NUMERO_LEZIONE = l.NUMERO 
group by c.ID, c.nome
having avg(f.stelle) >= 4;
