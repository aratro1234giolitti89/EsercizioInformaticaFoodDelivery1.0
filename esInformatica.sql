```sql
CREATE TABLE COMUNE (
    IDcomune INT PRIMARY KEY,
    nome VARCHAR(50)
);
```

```sql
CREATE TABLE ZONA (
    IDzona INT PRIMARY KEY
);
```

```sql
CREATE TABLE RISTORANTE (
    IDristorante INT PRIMARY KEY,
    indirizzo VARCHAR(100)
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
CREATE TABLE PROMOZIONE (
    IDpromozione INT PRIMARY KEY,
    dataInizio DATE,
    dataFine DATE,
    nome VARCHAR(50),
     CHECK (dataInizio <= dataFine)
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
