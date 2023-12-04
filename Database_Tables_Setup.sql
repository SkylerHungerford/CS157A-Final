DROP SCHEMA IF EXISTS SylviaHungerfordFinal;
CREATE SCHEMA SylviaHungerfordFinal;
USE SylviaHungerfordFinal;


CREATE TABLE Gender(
	GenderID				TINYINT			NOT NULL,
    GenderName				VARCHAR(16)		NOT NULL
);

ALTER TABLE Gender
	ADD CONSTRAINT Gender_PK_GenderID PRIMARY KEY (GenderID);
    
    
CREATE TABLE Account(
	AccountID				INT				NOT NULL,
    AccountName				VARCHAR(32)		NOT NULL,
    Message					VARCHAR(64)		NULL,
    GenderID				TINYINT			NOT NULL,
    DateOfBirth				DATE			NULL,
    AccountLv				SMALLINT		NOT NULL,
    ServantsOwned			SMALLINT		NOT NULL,
    MaxServantNumber		SMALLINT		NOT NULL,
    CEsOwned				SMALLINT		NOT NULL,
    MaxCENumber				SMALLINT		NOT NULL,
    CurrentSaintQuartz		INT				NOT NULL,
    CurrentRarePrisms		INT				NOT NULL,
    CurrentManaPrisms		INT				NOT NULL,
    CurrentQP				INT				NOT NULL,
    CurrentFP				INT				NOT NULL
);

ALTER TABLE Account
	ADD CONSTRAINT Account_PK_AccountID PRIMARY KEY (AccountID),
    ADD CONSTRAINT Account_FK_GenderID
		FOREIGN KEY (GenderID)
		REFERENCES Gender (GenderID)
        ON DELETE CASCADE,
	ADD CONSTRAINT Account_CHK_AccountID CHECK (AccountID>000000000 AND AccountID<=999999999),
	ADD CONSTRAINT Account_CHK_GenderID CHECK (GenderID=0 OR GenderID=1),
    ADD CONSTRAINT Account_CHK_AccountLv CHECK (AccountLv>=1 AND AccountLv<=170),
    ADD CONSTRAINT Account_CHK_MaxServantNumber CHECK (MaxServantNumber>=1 AND MaxServantNumber<=700),
    ADD CONSTRAINT Account_CHK_MaxCENumber CHECK (MaxCENumber>=1 AND MaxCENumber<=700),
    ADD CONSTRAINT Account_CHK_ServantsOwned CHECK (ServantsOwned>0 AND ServantsOwned <= MaxServantNumber),
    ADD CONSTRAINT Account_CHK_CEsOwned CHECK (CEsOwned>=0 AND CEsOwned <= MaxCENumber),
    ADD CONSTRAINT Account_CHK_CurrentSaintQuartz CHECK (CurrentSaintQuartz>=0 AND CurrentSaintQuartz <=999999999),
    ADD CONSTRAINT Account_CHK_CurrentRarePrisms CHECK (CurrentRarePrisms>=0 AND CurrentRarePrisms <=999999999),
    ADD CONSTRAINT Account_CHK_CurrentManaPrisms CHECK (CurrentManaPrisms>=0 AND CurrentManaPrisms <=999999999),
    ADD CONSTRAINT Account_CHK_CurrentQP CHECK (CurrentQP>=0 AND CurrentQP <=2000000000),
    ADD CONSTRAINT Account_CHK_CurrentFP CHECK (CurrentFP>=0 AND CurrentFP <=999999999);
    

CREATE TABLE Class(
	ClassID					TINYINT			NOT NULL,
    ClassName				VARCHAR(16)		NOT NULL
);

ALTER TABLE Class
	ADD CONSTRAINT Class_PK_ClassID PRIMARY KEY (ClassID);
    


CREATE TABLE MasterServantList(
	ServantID				SMALLINT		NOT NULL,
    ServantName				VARCHAR(32)		NOT NULL,
    ClassID					TINYINT			NOT NULL,
    GenderID				TINYINT			NOT NULL,
    ServantBaseRarity		TINYINT			NOT NULL,
    ServantBaseAtk			SMALLINT		NOT NULL,
    ServantMaxAtk			SMALLINT		NOT NULL,
    ServantBaseHP			SMALLINT		NOT NULL,
    ServantMaxHP			SMALLINT		NOT NULL
);

ALTER TABLE MasterServantList
	ADD CONSTRAINT MSL_PK_ServantID PRIMARY KEY (ServantID),
    ADD CONSTRAINT MSL_FK_ClassID
		FOREIGN KEY (ClassID)
		REFERENCES Class (ClassID)
        ON DELETE CASCADE,
	ADD CONSTRAINT MSL_FK_GenderID
		FOREIGN KEY (GenderID)
		REFERENCES Gender (GenderID)
        ON DELETE CASCADE,
	ADD CONSTRAINT MSL_CHK_ServantBaseRarity CHECK (ServantBaseRarity >0 AND ServantBaseRarity < 6);
#should be a way to make this table read-only, but I can't figure out how to read-only a specific table, so oh well
#Since this table is supposed to only be predefined content, putting constraints to ensure integrity on each column
# should be unnecessary. In theory at least. In practice it might be smart, but here it saves a little bit of performance
# to not have unnecessary constraints

CREATE TABLE PrivateServantList(
	ServantInventoryID		SMALLINT		NOT NULL,
    ServantID				SMALLINT		NOT NULL,
    AccountID				INT				NOT NULL,
    ServantLv				TINYINT			NOT NULL,
    AscensionNumber			TINYINT			NOT NULL,
    ServantAtk				SMALLINT		NOT NULL,
    ServantHP				SMALLINT		NOT NULL,
    Skill1Lv				TINYINT			NOT NULL,
    Skill2Lv				TINYINT			NOT NULL,
    Skill3Lv				TINYINT			NOT NULL,
    NPLv					TINYINT			NOT NULL,
    BondLv					TINYINT			NOT NULL
);
#ideally ServantInventoryID would auto increment, but I can't use a composite key for that and I'm not prepared
# to make unique tables for each account (yet)
ALTER TABLE PrivateServantList
	ADD CONSTRAINT PSL_PK	PRIMARY KEY (ServantInventoryID, AccountID),
    ADD CONSTRAINT PSL_FK_ServantID
		FOREIGN KEY (ServantID)
		REFERENCES MasterServantList (ServantID)
        ON DELETE CASCADE,
	ADD CONSTRAINT PSL_FK_AccountID
		FOREIGN KEY (AccountID)
        REFERENCES Account (AccountID)
        ON DELETE CASCADE,
	ADD CONSTRAINT PSL_CHK_ServantLv CHECK (ServantLv>0 AND ServantLv <= 120),
    ADD CONSTRAINT PSL_CHK_AscensionNumber CHECK (AscensionNumber>=0 AND AscensionNumber<=4),
    ADD CONSTRAINT PSL_CHK_Skill1Lv CHECK (Skill1Lv>=1 AND Skill1Lv<=10),
    ADD CONSTRAINT PSL_CHK_Skill2Lv CHECK (Skill2Lv>=1 AND Skill2Lv<=10),
    ADD CONSTRAINT PSL_CHK_Skill3Lv CHECK (Skill3Lv>=1 AND Skill3Lv<=10),
    ADD CONSTRAINT PSL_CHK_NPLv CHECK (NPLv>=1 AND NPLv<=5),
    ADD CONSTRAINT PSL_CHK_BondLv CHECK (BondLv>=0 AND BondLv<=15);



#need to add to design phase again
CREATE TABLE CERarityToMaxLevel(
	CERarity				TINYINT			NOT NULL PRIMARY KEY,
    CEMaxLevel				TINYINT			NOT NULL
);

CREATE TABLE MasterCraftEssenceList(
	CEID					SMALLINT		NOT NULL,
    CEName					VARCHAR(32)		NOT NULL,
    CERarity				TINYINT			NOT NULL,
    CEBaseAtk				SMALLINT		NOT NULL,
	CEMaxAtk				SMALLINT		NOT NULL,
	CEBaseHP				SMALLINT		NOT NULL,
	CEMaxHP					SMALLINT		NOT NULL
);

ALTER TABLE MasterCraftEssenceList
	ADD CONSTRAINT MCEL_PK_CEID PRIMARY KEY (CEID),
    ADD CONSTRAINT MCEL_FK_CERarity
		FOREIGN KEY (CERarity)
        REFERENCES CERarityToMaxLevel (CERarity)
        ON DELETE CASCADE;
#similar to the MasterServantList, we assume that since the MasterCraftEssenceList is (in theory) read-only,
# anyone with access to insert into it knows what they're doing for the values they input.

CREATE TABLE PrivateCraftEssenceList(
	CEInventoryID			SMALLINT		NOT NULL,
    CEID					SMALLINT		NOT NULL,
    AccountID				Int				NOT NULL,
    CELv					TINYINT			NOT NULL,
    CEAtk					SMALLINT		NOT NULL,
    CEHP					SMALLINT		NOT NULL,
    LBNumber				TINYINT			NOT NULL
);
#ideally CEInventoryID would auto increment, but I can't use a composite key for that and I'm not prepared
# to make unique tables for each account (yet)

ALTER TABLE PrivateCraftEssenceList
	ADD CONSTRAINT PCEL_PK PRIMARY KEY (CEInventoryID, AccountID),
    ADD CONSTRAINT PCEL_FK_CEID
		FOREIGN KEY (CEID)
        REFERENCES MasterCraftEssenceList (CEID)
        ON DELETE CASCADE,
	ADD CONSTRAINT PCEL_FK_AccountID
		FOREIGN KEY (AccountID)
		REFERENCES Account (AccountID)
        ON DELETE CASCADE;
#need some checks against the max values of a given CE, but that's a problem for Tomorrow's Syl

CREATE TABLE Party(
	PartyID					TINYINT			NOT NULL,
    AccountID				INT				NOT NULL,
    PS1Servant				SMALLINT		NULL,
	PS2Servant				SMALLINT		NULL,
    PS3Servant				SMALLINT		NULL,
    PS4Servant				SMALLINT		NULL,
    PS5Servant				SMALLINT		NULL,
	PS1CE					SMALLINT		NULL,
	PS2CE					SMALLINT		NULL,
	PS3CE					SMALLINT		NULL,
	PS4CE					SMALLINT		NULL,
	PS5CE					SMALLINT		NULL
);

ALTER TABLE Party
	ADD CONSTRAINT Party_PK PRIMARY KEY (PartyID, AccountID),
    ADD CONSTRAINT Party_FK_AccountID
		FOREIGN KEY (AccountID)
		REFERENCES Account (AccountID),
    ADD CONSTRAINT Party_FK_PS1Servant
		FOREIGN KEY (PS1Servant)
        REFERENCES PrivateServantList (ServantInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS2Servant
		FOREIGN KEY (PS2Servant)
        REFERENCES PrivateServantList (ServantInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS3Servant
		FOREIGN KEY (PS3Servant)
        REFERENCES PrivateServantList (ServantInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS4Servant
		FOREIGN KEY (PS4Servant)
        REFERENCES PrivateServantList (ServantInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS5Servant
		FOREIGN KEY (PS5Servant)
        REFERENCES PrivateServantList (ServantInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS1CE
		FOREIGN KEY (PS1CE)
        REFERENCES PrivateCraftEssenceList (CEInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS2CE
		FOREIGN KEY (PS2CE)
        REFERENCES PrivateCraftEssenceList (CEInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS3CE
		FOREIGN KEY (PS3CE)
        REFERENCES PrivateCraftEssenceList (CEInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS4CE
		FOREIGN KEY (PS4CE)
        REFERENCES PrivateCraftEssenceList (CEInventoryID)
        ON DELETE CASCADE,
    ADD CONSTRAINT Party_FK_PS5CE
		FOREIGN KEY (PS5CE)
        REFERENCES PrivateCraftEssenceList (CEInventoryID)
        ON DELETE CASCADE,
	ADD CONSTRAINT Party_CHK_PartyID CHECK (PartyID >=1 AND PartyID<=10),
    ADD CONSTRAINT Party_CHK_UniqueServants CHECK 
					((NOT (PS1Servant = PS2Servant)) AND
                    (NOT (PS1Servant = PS3Servant)) AND
                    (NOT (PS1Servant = PS4Servant)) AND
                    (NOT (PS1Servant = PS5Servant)) AND
                    (NOT (PS2Servant = PS3Servant)) AND
                    (NOT (PS2Servant = PS4Servant)) AND
                    (NOT (PS2Servant = PS5Servant)) AND
                    (NOT (PS3Servant = PS4Servant)) AND
                    (NOT (PS3Servant = PS5Servant)) AND
                    (NOT (PS4Servant = PS5Servant))),
		#this is NOT how its supposed to be. This only checks that the inventoryID isn't duplicated
		#	I need to be checking the actual servant id, but that's more than I know how to do at this moment
	ADD CONSTRAINT Party_CHK_NoOneCETwice CHECK 
					((NOT (PS1CE = PS2CE)) AND
                    (NOT (PS1CE = PS3CE)) AND
                    (NOT (PS1CE = PS4CE)) AND
                    (NOT (PS1CE = PS5CE)) AND
                    (NOT (PS2CE = PS3CE)) AND
                    (NOT (PS2CE = PS4CE)) AND
                    (NOT (PS2CE = PS5CE)) AND
                    (NOT (PS3CE = PS4CE)) AND
                    (NOT (PS3CE = PS5CE)) AND
                    (NOT (PS4CE = PS5CE)));			


/*CREATE VIEW OwnedSaberServants AS
	SELECT * 
    FROM */