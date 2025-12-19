## Codice DDL

```sql
/*
Vincoli usati:
CHECK (Email LIKE '%@%') → vincolo di dominio sulla struttura dell’email
Impedisce l’inserimento di email non valide.
*/
CREATE TABLE CLIENTE (

    Email VARCHAR(100) PRIMARY KEY,
    nTel VARCHAR(20) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    CHECK (Email LIKE '%@%')
);
```

```sql
CREATE TABLE COMUNE (
    IDcomune INT PRIMARY KEY,
    nome VARCHAR(50)
);
```

```sql
/*
FOREIGN KEY verso CLIENTE con ON DELETE CASCADE

FOREIGN KEY verso COMUNE con ON DELETE RESTRICT

Un indirizzo deve appartenere a un cliente esistente.
Se un cliente viene eliminato, i suoi indirizzi non hanno senso; invece un comune non può essere eliminato se ancora usato.
*/
CREATE TABLE INDIRIZZO (
    IDindirizzo INT PRIMARY KEY,
    FK_Email VARCHAR(100),
    FK_IDcomune INT,
   FOREIGN KEY (FK_Email) REFERENCES CLIENTE(Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDcomune) REFERENCES COMUNE(IDcomune)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

```sql
/*
CHECK (stato IN (...)) → vincolo di dominio

FOREIGN KEY verso CLIENTE (CASCADE)

FOREIGN KEY verso INDIRIZZO (RESTRICT)

Ogni ordine deve avere uno stato valido ed essere associato a un cliente e a un indirizzo esistente.
*/
CREATE TABLE ORDINE (
    IDordine INT PRIMARY KEY,
    stato VARCHAR(30),
    FKEmail VARCHAR(100),
    FKIDindirizzo INT,
    CHECK (stato IN ('ricevuto', 'in preparazione', 'in consegna', 'consegnato')),
    FOREIGN KEY (FKEmail) REFERENCES CLIENTE(Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FKIDindirizzo) REFERENCES INDIRIZZO(IDindirizzo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

```sql
/*
CHECK (LENGTH(CF) = 16)

La lunghezza del codice fiscale non può essere diversa da 16.
*/
CREATE TABLE RIDER (
    CF VARCHAR(16) PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    iban VARCHAR(34),
     CHECK (LENGTH(CF) = 16)
);
```

```sql
CREATE TABLE ZONA (
    IDzona INT PRIMARY KEY
);
```

```sql
/*
CHECK (orarioApertura < orarioChiusura) → vincolo di tupla

Garantisce orari coerenti.
*/
CREATE TABLE GIORNO (
    IDgiorno INT PRIMARY KEY,
    nome VARCHAR(20),
    orarioApertura TIME,
    orarioChiusura TIME,
     CHECK (orarioApertura < orarioChiusura)
);
```

```sql
CREATE TABLE RISTORANTE (
    IDristorante INT PRIMARY KEY,
    indirizzo VARCHAR(100)
);
```

```sql
/*
CHECK (prezzo > 0)

FOREIGN KEY verso RISTORANTE (CASCADE)

Un piatto non può esistere senza ristorante e deve avere un prezzo valido.
*/
CREATE TABLE PIATTO (
    IDpiatto INT PRIMARY KEY,
    prezzo DECIMAL(6,2),
    disponibilita BOOLEAN,
    FK_IDristorante INT,
    CHECK (prezzo > 0),
    FOREIGN KEY (FK_IDristorante) REFERENCES RISTORANTE(IDristorante)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE INGREDIENTE (
    IDingrediente INT PRIMARY KEY,
    nome VARCHAR(50),
    quantita VARCHAR(30)
);
```

```sql
CREATE TABLE ALLERGENE (
    IDallergene INT PRIMARY KEY,
    nome VARCHAR(50),
    personalizzazioni VARCHAR(100)
);
```

```sql
CREATE TABLE METODO_PAGAMENTO (
    IDmetodo INT PRIMARY KEY
);
```

```sql
/*
CHECK (LENGTH(Ncarta) BETWEEN 13 AND 20)

FOREIGN KEY verso METODO_PAGAMENTO (CASCADE)

Ogni carta è associata a un solo metodo di pagamento.
*/
CREATE TABLE CARTA (
    FK_IDmetodo INT PRIMARY KEY,
    pagaInApp BOOLEAN,
    banca VARCHAR(50),
    Ncarta VARCHAR(20) unique,
    CHECK (LENGTH(Ncarta) BETWEEN 13 AND 20),
    FOREIGN KEY (FK_IDmetodo) REFERENCES METODO_PAGAMENTO(IDmetodo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
/*
CHECK (stelle BETWEEN 1 AND 5)

FOREIGN KEY verso ORDINE (CASCADE)

Un ordine può avere una sola recensione e la valutazione deve essere valida.
*/
CREATE TABLE RECENSIONE (
    IDrecensione INT PRIMARY KEY,
    descrizione VARCHAR(255),
    stelle INT CHECK (stelle BETWEEN 1 AND 5),
    FK_IDordine INT,
    CHECK (stelle BETWEEN 1 AND 5),
    FOREIGN KEY (FK_IDordine) REFERENCES ORDINE(IDordine)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE PROMOZIONE (
    IDpromozione INT PRIMARY KEY,
    dataInizio DATE,
    dataFine DATE,
    nome VARCHAR(50),
     CHECK (dataInizio <= dataFine)
);
```

```sql
/*
RIMARY KEY composta

FOREIGN KEY con ON DELETE CASCADE

Impediscono duplicazioni della stessa relazione e garantiscono che le associazioni esistano solo tra entità valide.

Questo è valido per tutte le tabelle ausiliarie che seguono.
*/
CREATE TABLE ORDINE_RIDER (
    FK_IDordine INT,
    FK_CF VARCHAR(16),
    PRIMARY KEY (FK_IDordine, FK_CF),
     FOREIGN KEY (FK_IDordine) REFERENCES ORDINE(IDordine)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_CF) REFERENCES RIDER(CF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE RIDER_ZONA (
    FK_CF VARCHAR(16),
    FK_IDzona INT,
    PRIMARY KEY (FK_CF, FK_IDzona),
     FOREIGN KEY (FK_CF) REFERENCES RIDER(CF)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDzona) REFERENCES ZONA(IDzona)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE ZONA_COMUNE (
    FK_IDzona INT,
    FK_IDcomune INT,
    PRIMARY KEY (FK_IDzona, FK_IDcomune),
    FOREIGN KEY (FK_IDzona) REFERENCES ZONA(IDzona)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDcomune) REFERENCES COMUNE(IDcomune)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE ORDINE_PAGAMENTO (
    FK_IDordine INT,
    FK_IDmetodo INT,
    PRIMARY KEY (FK_IDordine, FK_IDmetodo),
     FOREIGN KEY (FK_IDordine) REFERENCES ORDINE(IDordine)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDmetodo) REFERENCES METODO_PAGAMENTO(IDmetodo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE ORDINE_PROMOZIONE (
    FK_IDordine INT,
    FK_IDpromozione INT,
    PRIMARY KEY (FK_IDordine, FK_IDpromozione),
     FOREIGN KEY (FK_IDordine) REFERENCES ORDINE(IDordine)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDpromozione) REFERENCES PROMOZIONE(IDpromozione)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE PROMOZIONE_PIATTO (
    FK_IDpromozione INT,
    FK_IDpiatto INT,
    PRIMARY KEY (FK_IDpromozione, FK_IDpiatto),
    FOREIGN KEY (FK_IDpromozione) REFERENCES PROMOZIONE(IDpromozione)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDpiatto) REFERENCES PIATTO(IDpiatto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE PIATTO_ORDINE (
    FK_IDpiatto INT,
    FK_IDordine INT,
    PRIMARY KEY (FK_IDpiatto, FK_IDordine),
    FOREIGN KEY (FK_IDpiatto) REFERENCES PIATTO(IDpiatto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDordine) REFERENCES ORDINE(IDordine)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
```

```sql
CREATE TABLE INGREDIENTE_PIATTO (
    FK_IDingrediente INT,
    FK_IDpiatto INT,
    PRIMARY KEY (FK_IDingrediente, FK_IDpiatto),
    FOREIGN KEY (FK_IDingrediente) REFERENCES INGREDIENTE(IDingrediente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDpiatto) REFERENCES PIATTO(IDpiatto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE INGREDIENTE_ALLERGENE (
    FK_IDingrediente INT,
    FK_IDallergene INT,
    PRIMARY KEY (FK_IDingrediente, FK_IDallergene),
    FOREIGN KEY (FK_IDingrediente) REFERENCES INGREDIENTE(IDingrediente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDallergene) REFERENCES ALLERGENE(IDallergene)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

```sql
CREATE TABLE RISTORANTE_GIORNO (
    FK_IDristorante INT,
    FK_IDgiorno INT,
    PRIMARY KEY (FK_IDristorante, FK_IDgiorno),
    FOREIGN KEY (FK_IDristorante) REFERENCES RISTORANTE(IDristorante)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FK_IDgiorno) REFERENCES GIORNO(IDgiorno)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

