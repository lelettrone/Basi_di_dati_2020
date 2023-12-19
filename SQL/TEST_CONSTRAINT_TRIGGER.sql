
--TEST CONSTRAINT
INSERT INTO UNITADIAPPRENDIMENTO VALUES(3,1,1,'test','test'); --Testo e video non possono coesistere

INSERT INTO STUDENTI VALUES(10, 'Mario', 'Rossi', 'BHORSS9992223478', 'mario@rossi@email.it', '366266C716B5843854AF039851828F5E', '@mrRossi', 0); --La mail ha due @
--TEST TRIGGER

INSERT INTO FEEDBACK VALUES(4,6,3,2);               --Lo studente sta valutando una lezione a cui non ha accesso

INSERT INTO VALUTAZIONI VALUES(3,2,'test trigger'); --Lo studente sta valutando un corso a cui non ha accesso

INSERT INTO LEZIONI VALUES (10,1,'test trigger');   --Si sta cercando di inserire la lezione 10 senza quelle precedenti

