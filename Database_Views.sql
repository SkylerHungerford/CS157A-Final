USE SylviaHungerfordFinal;
DROP VIEW IF EXISTS MasterListSaberServants;
DROP VIEW IF EXISTS MasterListArcherServants;
DROP VIEW IF EXISTS MasterListLancerServants;
DROP VIEW IF EXISTS MasterListRiderServants;
DROP VIEW IF EXISTS MasterListCasterServants;
DROP VIEW IF EXISTS MasterListAssassinServants;
DROP VIEW IF EXISTS MasterListBerserkerServants;
DROP VIEW IF EXISTS MasterListExtraServants;
DROP VIEW IF EXISTS MasterListRarity5Servants;
DROP VIEW IF EXISTS MasterListRarity5CEs;
DROP VIEW IF EXISTS LeonardosOwnedServants;
DROP VIEW IF EXISTS ShirousOwnedServants;


CREATE VIEW MasterListSaberServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 1;    
CREATE VIEW MasterListArcherServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 2;
CREATE VIEW MasterListLancerServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 3;
CREATE VIEW MasterListRiderServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 4;
CREATE VIEW MasterListCasterServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 5;
CREATE VIEW MasterListAssassinServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 6;
CREATE VIEW MasterListBerserkerServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 7;
CREATE VIEW MasterListExtraServants AS
	SELECT *
    FROM MasterServantList
    WHERE ClassID = 0 OR ClassID = 8;
CREATE VIEW MasterListRarity5Servants AS
	SELECT *
    FROM MasterServantList
    WHERE ServantBaseRarity = 5;
CREATE VIEW MasterListRarity5CEs AS
	SELECT *
    FROM MasterCraftEssenceList
    WHERE CERarity = 5;
    
CREATE VIEW LeonardosOwnedServants AS
	SELECT	ServantInventoryID, ServantName, ClassName, ServantLv
    FROM	PrivateServantList a	
			JOIN MasterServantList b ON a.ServantID = b.ServantID
            JOIN Class c ON b.ClassID = c.ClassID
	WHERE	a.AccountID = 999999999;
CREATE VIEW ShirousOwnedServants AS
	SELECT	ServantInventoryID, ServantName, ClassName, ServantLv
    FROM	PrivateServantList a	
			JOIN MasterServantList b ON a.ServantID = b.ServantID
            JOIN Class c ON b.ClassID = c.ClassID
	WHERE	a.AccountID = 444444444;